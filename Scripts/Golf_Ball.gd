extends RigidBody
#Golf_Ball.gd
export var STATE = "still"
#States:
#still = ball not moving
#moving = moving

func _ready():
	#Load textures and things later
	#maybe tie this to signal router?
	get_parent().get_parent().get_node("Kill_Volume").get_node("Area").connect("oob",self,"_on_oob")

func _process(delta):
	if get_linear_velocity().length() <= .01:
		STATE = "still"
	else:
		STATE = "moving"
		
func _on_oob():
	print("reset")
	set_linear_velocity(Vector3(0,0,0))
	set_translation(get_node("Arrow").last_pos)
