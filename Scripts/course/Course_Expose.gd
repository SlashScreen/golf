extends Spatial

export(Resource) var mesh_path
signal meshready
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Course_Mesh").mesh = mesh_path
	emit_signal("meshready")
