extends MeshInstance
#Sets up course collision mesh.

func _ready():
	print("\n MESH SETUP " + str(get_parent().get_parent().name) + "\n")
	print(str(get_mesh()))
	get_parent().get_node("Course_Collider").set_shape(get_mesh().create_trimesh_shape())
