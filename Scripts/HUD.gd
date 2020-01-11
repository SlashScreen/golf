extends Control

onready var game_vars = get_node("/root/Signal_Router").gameVars

func _ready():
	get_tree().get_root().get_node("Signal_Router").connect("on_won",self,"_on_hole")
	get_tree().get_root().get_node("Signal_Router").connect("clearHud",self,"_clear")
	_clear()

func _process(delta): #set text
	var cplayer = game_vars.players[game_vars.currentPlayer]
	get_node("Stroke").set_text("Stroke: "+str(cplayer.stroke))
	get_node("Par").set_text("Par "+ str(cplayer.par))
	get_node("Hole").set_text("Hole "+ str(cplayer.hole))

func _on_hole():
	#Set text based on score vs par relationship
	var text = ""
	var cplayer = game_vars.players[game_vars.currentPlayer]
	var rel = cplayer.par - cplayer.stroke #rel = relationship
	if cplayer.stroke == 1:
		text = "Hole in One!"
	#I know this is quite unsightly BUT there are no switch statements...
	elif rel < -3:
		text = "Too Bad!"
	elif rel == -3:
		text = "Triple Bogey!"
	elif rel == -2:
		text = "Double Bogey!"
	elif rel == -1:
		text = "Bogey!"
	elif rel == 0:
		text = "Par!"
	elif rel == 1:
		text = "Birdie!"
	elif rel >= 2:
		text = "Eagle!"
	get_node("Victory").set_text(text)

func _clear():
	get_node("Victory").set_text("")
