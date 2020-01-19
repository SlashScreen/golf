extends MeshInstance

export var player = 0
export var color = Vector3()
export var show = false
export var tracking = true
onready var game_vars = get_node("/root/Signal_Router").gameVars

func _ready():
	self.material_override.set_shader_param("Color",color)

func _physics_process(delta):
	if !show and tracking and game_vars.currentPlayer == player:
		hide()
		#ah, yes. one of the most convoluted pieces of code I've ever written.
		set_translation((get_parent().get_parent().get_node("Golf_Ball_Obj").get_node("Ball").get_global_transform().origin))
	if show:
		show()

func move():
	if game_vars.currentPlayer == player:
		var o = get_node("/root/Signal_Router").levels[game_vars.map].holes[str(game_vars.players[game_vars.currentPlayer].hole)].origin
		set_translation(Vector3(o.x,o.y,o.z))
		#tracking = false
