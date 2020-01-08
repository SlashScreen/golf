extends Control

onready var game_vars = get_node("/root/Signal_Router").gameVars

func _ready():
	get_tree().get_root().get_node("Signal_Router").connect("on_won",self,"_on_hole")
	get_tree().get_root().get_node("Signal_Router").connect("clearHud",self,"_clear")

func _process(delta): #set text
	get_node("Stroke").set_text("Stroke: "+str(game_vars.currentScore))
	get_node("Par").set_text("PAR "+ str(game_vars.par))

func _on_hole():
	#Set text based on score vs par relationship
	var text = ""
	var rel = game_vars.par-game_vars.currentScore #rel = relationship
	if game_vars.currentScore == 1:
		text = "Hole in One!"
	#I know this is quite unsightly BUT there are no switch statements...
	elif rel < -3:
		text = "Too Bad!"
	elif rel == -3:
		text = "Triple Bogey!"
	elif rel == -2:
		text = "Double Bogey!"
	elif rel == -1:
		text == "Bogey!"
	elif rel == 0:
		text = "Par!"
	elif rel == 1:
		text = "Birdie!"
	elif rel >= 2:
		text = "Eagle!"
	get_node("Victory").set_text(text)

func _clear():
	get_node("Victory").set_text("")
