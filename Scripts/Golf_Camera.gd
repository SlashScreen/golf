extends Camera

export var distance = 4
export var height = 2
export var iso = false
export var frozen = false
var rotator = 0 #in degrees
var uprot = 0
var ROT_SPEED = 3
var SCROLL_SPEED = .5

func _ready():
	set_physics_process(true)
	set_as_toplevel(true)
	get_node("/root/Signal_Router").connect("freeze",self,"freeze")
	if iso:
		set_projection(1)
	else:
		set_projection(0)

func freeze(c): #sets frozen to c, bool
	frozen = c

func _physics_process(delta):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0,1,0) #NTS: change up vector to gravity
	if iso:
		pos = target + Vector3(distance,distance,distance)
		#set_fov((distance/10)*178)
	elif not frozen:
		set_fov(70)
		var offset = pos - target
		if Input.is_action_pressed("cam_left"):
			rotator = -ROT_SPEED
		elif Input.is_action_pressed("cam_right"):
			rotator = ROT_SPEED
		else:
			rotator = 0
		if Input.is_action_pressed("cam_up"):
			uprot = ROT_SPEED
		elif Input.is_action_pressed("cam_down"):
			uprot = -ROT_SPEED
		else:
			uprot = 0
		distance = clamp(distance,.5,10)
		offset = (offset.normalized().rotated(up,(rotator*(PI/180))).rotated(Vector3.RIGHT,(uprot*(PI/180))))*distance
		#offset.y = height - fix do it doesnt drift towards ground
		
		pos = target + offset
	
	if pos != target:
		look_at_from_position(pos, target, up)

func _input(event):
	if event.is_action_pressed("cam_zoom_in"):
		distance-=SCROLL_SPEED
	elif event.is_action_pressed("cam_zoom_out"):
		distance+=SCROLL_SPEED
