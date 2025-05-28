extends CharacterBody3D

const SPEED := 125.0
const JUMP_VELOCITY := 6.0
const ROTATION_SPEED := 12.0

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player_song: AudioStreamPlayer3D = %PlayerSong

var _last_movement_direction := Vector3.BACK
var _playing_song = false

func _ready() -> void:
	player_song.playing = true

func _physics_process(delta: float) -> void:
		
	player_song.stream_paused = !_playing_song
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var camera = get_tree().get_first_node_in_group("active_camera")
	var forward = camera.global_basis.z
	var right = camera.global_basis.x
	
	var move_dir = forward * dir.y + right * dir.x
	move_dir.y = 0.0
	move_dir = move_dir.normalized()
	
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = move_dir * SPEED * delta
	velocity.y = y_velocity + get_gravity().y * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		animation_player.play("RESET")  
		animation_player.play("jump")
	
	move_and_slide()
	
	_playing_song = true
	
	if move_dir.length() > 0.2:
		_last_movement_direction = move_dir
		if is_on_floor() and not  animation_player.is_playing():
			animation_player.play("walk")
		
		var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
		global_rotation.y = lerp_angle(global_rotation.y, target_angle - PI/3, ROTATION_SPEED * delta)
	elif is_on_floor():
		animation_player.play("RESET")
		_playing_song = false

func _get_active_camera() -> Camera3D:
	for camera in get_tree().get_nodes_in_group("cameras"):
		if camera.current:
			return camera
	
	return get_tree().get_first_node_in_group("cameras")
