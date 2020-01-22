extends Area

onready var golfBall = get_node("/root/Signal_Router").return_ball()

func _process(delta):
	if overlaps_body(golfBall):
		set_gravity_vector(get_node("Spline").get_curve().get_closest_point(to_local(golfBall.get_ball_transform().origin)))