extends MeshInstance
#diorama on the menu screen. It rotates
export var rate = 5
var rotator = 1

func _process(delta):
	rotator += delta*rate
	set_rotation_degrees(Vector3(0,rotator,0))
