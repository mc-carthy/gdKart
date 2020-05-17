extends MeshInstance

func _process(delta: float) -> void:
	var parent_rotation = get_parent().global_transform.basis.get_euler()
	global_transform.basis = Basis(Vector3.UP, parent_rotation.y)
