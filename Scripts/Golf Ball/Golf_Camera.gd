extends Camera
#golf ball camera
export var distance = 4
export var height = 2
export var iso = false #isometric
export var frozen = false
var rotator = 0 #in degrees
var uprot = 0
var ROT_SPEED = 3
var SCROLL_SPEED = .5

func _ready():
	#unlocks it
	set_physics_process(true)
	set_as_toplevel(true)
	#connect
	get_node("/root/Signal_Router").connect("freeze",self,"freeze")
	#sets projection
	if iso:
		set_projection(1)
	else:
		set_projection(0)

func freeze(c): #sets frozen to c, bool
	frozen = c

func _physics_process(delta):
	#variables
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0,1,0) #NTS: change up vector to gravity
	#logic
	if iso: #if isometric
		pos = target + Vector3(distance,distance,distance)
		#set_fov((distance/10)*178)
	elif not frozen: #if perspective and also unfrozen
		#set_fov(70)
		var offset = pos - target
		#control
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
		#rotation and distance math
		distance = clamp(distance,.5,10)
		offset = (offset.normalized().rotated(up,(rotator*(PI/180))).rotated(Vector3.RIGHT,(uprot*(PI/180))))*distance
		#offset.y = height - fix do it doesnt drift towards ground
		#change position
		pos = target + offset
	
	if pos != target: #if the camera is not exactly where the ball is, look at the ball
		look_at_from_position(pos, target, up)

func _input(event): #other input- scroll
	if event.is_action_pressed("cam_zoom_in"):
		distance-=SCROLL_SPEED
	elif event.is_action_pressed("cam_zoom_out"):
		distance+=SCROLL_SPEED
