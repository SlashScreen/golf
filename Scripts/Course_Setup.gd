extends MeshInstance
#Sets up course collision mesh.
func _on_Course_meshready():
	create_trimesh_collision()
