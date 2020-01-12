extends MeshInstance
#Sets up course collision mesh.

func _ready():
	create_trimesh_collision()
	get_child(0).set_physics_material_override(load("res://Misc/Course_Material.tres"))
