extends Control

onready var game_vars = get_node("/root/Signal_Router").gameVars

func _ready():
	get_tree().get_root().get_node("Signal_Router").connect("on_won",self,"_on_hole")
	get_tree().get_root().get_node("Signal_Router").connect("clearHud",self,"_clear")
	get_tree().get_root().get_node("Signal_Router").connect("msg",self,"custom_message")
	_clear()

func _process(delta): #set text
	var cplayer = game_vars.players[game_vars.currentPlayer]
	get_node("Stroke").set_text("Stroke: "+str(cplayer.stroke))
	get_node("Par").set_text("Par "+ str(cplayer.par))
	get_node("Hole").set_text("Hole "+ str(cplayer.hole+1))
	get_node("Player").set_text("Player "+ str(game_vars.currentPlayer+1))

func custom_message(s):
	get_node("Victory").set_text(s);

func _on_hole():
	#Set text based on score vs par relationship
	var text = ""
	var cplayer = game_vars.players[game_vars.currentPlayer]
	var rel = cplayer.par - cplayer.stroke #rel = relationship
	if cplayer.stroke == 1:
		text = "Hole in One!"
	else:
		match int(rel):
			-4:
				text = "Too Bad!"
			-3:
				text = "Triple Bogey!"
			-2:
				text = "Double Bogey!"
			-1:
				text = "Bogey!"
			0:
				text = "Par!"
			1:
				text = "Birdie!"
			2:
				text = "Eagle!"
			3:
				text = "Albatross!"
			4:
				text = "Condor!"
			_:
				text = "Finished!"
	custom_message(text)

func _clear():
	get_node("Victory").set_text("")
