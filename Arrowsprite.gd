#Handles golf ball physics. May beed to move elsewhere, this is wierd
extends Sprite3D
#Constants


var ray_length = 1000
var max_power = 15
var end_dist = 7
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
#input
func _input(event):
	#raycast
	var cam = get_parent().get_parent().get_node("Camera")
	var space_state = cam.get_world().direct_space_state
	var mouse = event.position #event position
	var from = cam.project_ray_origin(mouse) #get origin
	var to = from + cam.project_ray_normal(mouse) * ray_length #get ray end
	var result = space_state.intersect_ray(to,from) #cast
	#apply on click
	if result.has('position'):
		var ball = get_parent() #ball
		var d = result.position.distance_to(get_translation()) #distance between points
		d = clamp(d,0,end_dist)
		#Add impulse
		result.position.y += 1
		var newdir = ball.get_translation().direction_to(result.position)
		look_at(result.position,Vector3(0,1,0)) #set_rotation(Vector3(0,newdir.y,0))
		set_scale(Vector3(1,1,d/end_dist))
		if event is InputEventMouseButton and event.pressed and event.button_index == 1: #if mouse button clicked
			ball.apply_central_impulse(newdir*((d/end_dist)*max_power)) #apply impulse
