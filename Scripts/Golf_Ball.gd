extends RigidBody
#Golf_Ball.gd
export var STATE = "still"
#States:
#still = ball not moving
#moving = moving

func _ready():
	#Load textures and things later
	pass#connect("oob",self,"_on_oob")

func _process(delta):
	print(get_translation())
	if get_linear_velocity().length() <= .01:
		STATE = "still"
	else:
		STATE = "moving"

func reset():
	print("Reset " + str(get_node("Arrow").last_pos))
	set_linear_velocity(Vector3(0,0,0))
	set_translation(get_node("Arrow").last_pos)
	print(get_translation())
