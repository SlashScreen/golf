extends Area

onready var golfBall = get_node("/root/Signal_Router").return_ball()

func _ready():
	set_linear_damp(golfBall.get_linear_damp())
	set_angular_damp(golfBall.get_angular_damp())
