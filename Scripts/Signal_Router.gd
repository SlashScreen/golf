extends Node
#handles signals and variables

##INIT###
export var gameVars = {}
onready var file = File.new()
var levels

func _ready():
	file.open("res://Levels/levels.json",File.READ)
	var levels = JSON.parse(file.get_as_text()).get_result()
	#set default score stuff. This shoudln't be a problem later since all holes will be in 1 scene
	gameVars.currentScore = 0
	gameVars.scorecard = []
	gameVars.par = 0
	gameVars.hole = 0
	gameVars.map = "test"
	print(levels[gameVars.map].info.name)
	
	var baseScene = get_parent().get_node("level")
	#baseScene.get_node("Golf_Hole_Volume").get_node("Hole_Area").connect("ball_in_hole",self,"_on_in_hole")
	baseScene.get_node("HUD").connect("gamewon",self,"_on_game_won")
	baseScene.get_node("Kill_Volume").get_node("Area").connect("oob",self,"on_oob")
###SCORE FUNCTIONS###
func new_hole(): #todo: add hole with json data n all that
	gameVars.par = 0 #todo: read json and get par
	gameVars.scorecard.append(gameVars.currentScore) #add to card
	gameVars.currentScore = 0 #reset stroke
	gameVars.hole += 1

func hard_reset():
	gameVars.scorecard = []
	gameVars.currentScore = 0
	gameVars.hole = 0
###SIGNAL PROCESSING###
func on_oob():
	gameVars.currentScore += 1
	print("Out Of Bounds!")

func _on_game_won(): #todo: win
	print("In Hole!")
	new_hole()
