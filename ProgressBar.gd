extends ProgressBar

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	return
	var ray_length = 1000
	var max_power = 500
	var end_dist = 1
	var mouse = get_viewport().get_mouse_position()
	var cam = owner.get_node("Camera")
	var from = cam.project_ray_origin(mouse)
	var to = from + cam.project_ray_normal(mouse) * ray_length
	var space_state = cam.get_world().direct_space_state
	var result = space_state.intersect_ray(to,from)

	if result.has('position'):
		var ball = get_tree().get_root().get_node("Spatial").get_node("Ball")
		var d = result.position.distance_to(ball.get_translation()) 
		#Add impulse
		ball.get_node("ArrowSprite").look_at(result.position,Vector3(0,1,0))
		#all.apply_central_impulse(ball.get_node("ArrowSprite").get_rotation()*((d/end_dist)/max_power))
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
