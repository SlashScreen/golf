extends MeshInstance

export var magnitude = 1
export var frequency = 1.0
var timer = 0.0

func _process(delta):
	timer += delta
	#print(cos(timer*60*frequency)*magnitude)
	get_transform().basis = get_transform().basis.rotated(Vector3.RIGHT,10)
	#print(get_transform())
