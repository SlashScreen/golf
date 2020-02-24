extends PathFollow

var progress = 0
var running = false
export var speed = 1
onready var length = get_parent().get_curve().get_baked_length()
signal finished

func _process(delta):
	if running:
		progress += speed
		if progress > length:
			running = false
			emit_signal("finished")
		else:
			set_offset(progress)

func _on_CourseCam_beginFollow():
	running = true
