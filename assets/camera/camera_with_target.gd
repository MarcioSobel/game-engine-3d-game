extends Camera3D

@export var target: Node3D

func _process(delta: float) -> void:
	look_at(target.position)
