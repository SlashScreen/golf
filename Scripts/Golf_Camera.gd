extends Camera

export var distance = 4
export var height = 2
var rotator = 0 #in degrees
var ROT_SPEED = 3

func _ready():
	set_physics_process(true)
	set_as_toplevel(true)

func _physics_process(delta):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0,1,0)
	var offset = pos - target
	
	if Input.is_key_pressed(KEY_A):
		rotator = -ROT_SPEED
	elif Input.is_key_pressed(KEY_D):
		rotator = ROT_SPEED
	else:
		rotator = 0
	
	offset = (offset.normalized().rotated(up,(rotator*(PI/180))))*distance
	offset.y = height
	
	pos = target + offset
	
	look_at_from_position(pos, target, up)
