extends Sprite3D
#Handles golf ball physics. May beed to move elsewhere, this is wierd

#vars
export var last_pos = Vector3(0,0,0)
onready var game_vars = get_node("/root/Signal_Router").gameVars
var ray_length = 1000
var max_power = 15
var end_dist = 2

func _process(delta):
	#hide, show, and hit based on ball state
	if get_parent().STATE == "still":
		show()
		#raytrace
		var cam = get_parent().get_node("camfollow/Camera")
		var space_state = cam.get_world().direct_space_state
		var mouse = get_viewport().get_mouse_position() #event position
		var from = cam.project_ray_origin(mouse) #get origin
		var to = from + cam.project_ray_normal(mouse) * ray_length #get ray end
		var result = space_state.intersect_ray(from,to) #cast
		#if mouse something
		if result.has('position'):
			#calculate mathy things
			var ball = get_parent() #ball
			var d = result.position.distance_to(get_global_transform().origin)#distance between points
			d = clamp(d,0,end_dist) #clamp to mximum distance
			#result.position.y = get_global_transform().origin.y #lock rotation
			result.position = result.position + (result.normal*.1)
			var newdir = ball.get_global_transform().origin.direction_to(result.position)
			#Point arrow and set size
			look_at(result.position,result.normal) #set_rotation(Vector3(0,newdir.y,0))
			set_scale(Vector3(.5,1,d/end_dist))
			self.material_override.set_shader_param("Power",(d/end_dist))
			#Hit ball
			if Input.is_mouse_button_pressed(BUTTON_LEFT): #if mouse button clicked
				last_pos = ball.get_transform().origin #set last position
				game_vars.players[game_vars.currentPlayer].stroke += 1 #yes I'm setting the score here. Shouldn't be too big of an issue
				ball.apply_central_impulse(newdir*((d/end_dist)*max_power)) #apply impulse
				ball.fromHit = true
				$HitSFX.play_once()
	else:
		hide()
