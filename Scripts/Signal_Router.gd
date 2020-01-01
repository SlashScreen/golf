extends Node
#handles signals and variables

##INIT###
export var gameVars = {}
export var par = 0
func _ready():
	gameVars.currentScore = 0
	gameVars.scorecard = []
	var baseScene = get_parent().get_node("level")
	baseScene.get_node("Golf_Hole_Volume").get_node("Hole_Area").connect("ball_in_hole",self,"_on_in_hole")
	baseScene.get_node("Kill_Volume").get_node("Area").connect("oob",self,"on_oob")
###SCORE FUNCTIONS###
func new_hole(): #todo: add hole with json data n all that
	par = 0
	gameVars.scorecard.append(gameVars.currentScore)
	gameVars.currentScore = 0

func hard_reset():
	gameVars.scorecard = []
	gameVars.currentScore = 0
###SIGNAL PROCESSING###
func on_oob():
	gameVars.currentScore += 1
	print("Out Of Bounds!")

func _on_in_hole():
	print("In Hole!")
	new_hole()
