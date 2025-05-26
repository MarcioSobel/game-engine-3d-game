class_name CameraSwitcher
extends Area3D

@export var target: Camera3D

func _on_body_entered(body: Node3D) -> void:
	var old_camera := get_tree().get_first_node_in_group("active_camera")
	if old_camera:
		old_camera.remove_from_group("active_camera")
	
	target.current = true
	target.add_to_group("active_camera")
