extends RigidBody
#Golf_Ball.gd
export var STATE = "still"
#States:
#still = ball not moving
#moving = moving
var should_move = false
var nextLocation = Vector3(0,0,0)

func _ready():
	#Load textures and things later
	get_tree().get_root().get_node("Signal_Router").connect("move_ball",self,"_on_move_ball")
	get_parent().get_parent().get_node("Kill_Volume").get_node("Area").connect("oob",self,"_on_oob")

func _process(delta):
	#TODO: make less finicky.
	#Process:
	#Get all the forces acting on it
	#If the forces balance to 0 AND the length is very small
	#THEN is still. Otherwise, it's moving
	#Or just... is sleeping
	
	#TODO: Stress test this
	if is_sleeping(): #get_linear_velocity().length() <= .01:
		STATE = "still"
	else:
		STATE = "moving"
		
func _on_oob(): #signal
	should_move = true
	nextLocation = get_node("Arrow").last_pos

func _on_move_ball(vec):
	should_move = true
	nextLocation = vec

func _integrate_forces(state): #Reset
	if should_move:
		should_move = false
		set_linear_velocity(Vector3(0,0,0)) #Make it stop moving
		set_angular_velocity(Vector3(0,0,0)) #Make it stop rotating
		state.transform.origin = nextLocation
