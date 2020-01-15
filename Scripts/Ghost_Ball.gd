extends MeshInstance

export var player = 0
export var color = Vector3()
export var show = false
onready var game_vars = get_node("/root/Signal_Router").gameVars

func _physics_process(delta):
	if !show and game_vars.currentPlayer == player:
		hide()
		#ah, yes. one of the single most convoluted pieces of code I've ever written.
		get_global_transform().origin = get_parent().get_parent().get_node("Golf_Ball_Obj").get_node("Ball").get_global_transform().origin
	if show:
		show()
