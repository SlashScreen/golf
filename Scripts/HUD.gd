extends Control

onready var game_vars = get_node("/root/Signal_Router").gameVars

func _ready():
	pass # Replace with function body.

#FUNCTIONS:
#Event ball in hole then display won text and all that
#Event hit ball then count up

func _process(delta):
	get_node("Stroke").set_text("Stroke: "+str(game_vars.currentScore))
	get_node("Par").set_text("PAR "+ str(game_vars.par))
