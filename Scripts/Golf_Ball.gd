extends RigidBody
#Golf_Ball.gd
export var STATE = "still"
#States:
#still = ball not moving
#moving = moving

func _ready():
	#Load textures and things later
	pass 

func _process(delta):
	if get_linear_velocity().length() <= .01:
		STATE = "still"
	else:
		STATE = "moving"
