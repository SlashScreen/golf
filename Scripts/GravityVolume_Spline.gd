extends Area

export var spline_resolution = 0.0
onready var golfBall = get_node("/root/Signal_Router").return_ball()

func _ready():
	set_linear_damp(golfBall.get_linear_damp())
	set_angular_damp(golfBall.get_angular_damp())

func _process(delta):
	if overlaps_body(golfBall):
		set_gravity_vector(nearest_point_on_spline(golfBall.get_ball_transform().origin,spline_resolution))
		
func nearest_point_on_spline(point, acc):
	#nts: acc = accuracy, how many points to test
	acc = float(acc)
	var closest = INF
	var closestPoint = Vector3()
	for i in range(acc):
		get_node("Spline/SplineHead").set_unit_offset(i/acc)
		var checkVec = get_node("Spline/SplineHead").get_transform().origin
		var d = point.distance_to(checkVec)
		if d < closest:
			closest = d
			closestPoint = checkVec
	return closestPoint
