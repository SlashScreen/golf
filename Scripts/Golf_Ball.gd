extends RigidBody
#Golf_Ball.gd
export var STATE = "still"
#States:
#still = ball not moving
#moving = moving
var should_reset = false

func _ready():
	#Load textures and things later
	#maybe tie this to signal router?
	get_parent().get_parent().get_node("Kill_Volume").get_node("Area").connect("oob",self,"_on_oob")

func _process(delta):
	#TODO: make less finicky.
	if get_linear_velocity().length() <= .01:
		STATE = "still"
	else:
		STATE = "moving"
		
func _on_oob(): #signal
	should_reset = true

func _integrate_forces(state): #Reset
	if should_reset:
		should_reset = false
		set_linear_velocity(Vector3(0,0,0)) #Make it stop moving
		set_angular_velocity(Vector3(0,0,0)) #Make it stop rotating
		state.transform.origin = get_node("Arrow").last_pos
