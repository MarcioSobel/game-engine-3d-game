extends SpotLight3D

func _process(delta: float) -> void:
	visible = get_parent().current
