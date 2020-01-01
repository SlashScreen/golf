extends Node
#handles signals and variables
export var gameVars = {}
export var par = 0

func _ready():
	gameVars.currentScore = 0
	gameVars.scorecard = []
	get_parent().get_node("level").get_node("Kill_Volume").get_node("Area").connect("oob",self,"on_oob")

func new_hole():
	par = 0
	gameVars.scorecard.append(gameVars.currentScore)
	gameVars.currentScore = 0

func hard_reset():
	gameVars.scorecard = []
	gameVars.currentScore = 0

func on_oob():
	print("Out Of Bounds!")
