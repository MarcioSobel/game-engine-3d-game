extends Camera3D

@export var target: Node3D
@export_range(0.0, 0.5, 0.05) var follow_speed := 0.05

func _process(delta: float) -> void:
	var old_rotation := rotation
	look_at(target.position)
	rotation = lerp(old_rotation, rotation, follow_speed)
