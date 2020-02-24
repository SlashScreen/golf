extends Spatial

var progress = 0
var rot = Vector3()
var active = false
signal holeFinished

func _ready():
	rot.x = 45

func _process(delta):
	if active:
		progress += 5
		rot.y = progress
		if progress > 360:
			active = false
			emit_signal("holeFinished")
			get_child(0).set_current(false)
		else:
			set_global_transform(get_parent().get_parent().get_node("Golf_Hole_Volume").get_global_transform())
			set_rotation(rot)

func _on_CourseCam_holeCam():
	active = true
	get_child(0).set_current(true)
