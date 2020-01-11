extends Node
#handles signals and variables

##INIT###
export var gameVars = {}
onready var file = File.new()
var levels
onready var baseScene = get_parent().get_node("level")
onready var t = get_node("/root/DelayManager")

signal move_ball(vec)
signal on_oob
signal on_won
signal clearHud

func _ready():
	file.open("res://Levels/levels.json",File.READ)
	levels = JSON.parse(file.get_as_text()).get_result()
	file.close()
	
	gameVars.currentScore = 0
	gameVars.scorecard = []
	gameVars.par = 0
	gameVars.hole = 0
	gameVars.map = "test"
	print(levels[gameVars.map].info.name)
	
	baseScene.get_node(str(gameVars.hole)).get_node("Kill_Volume").get_node("Area").connect("oob",self,"on_oob")
	baseScene.get_node(str(gameVars.hole)).get_node("Golf_Hole_Volume").get_node("Hole_Area").connect("ball_in_hole",self,"on_game_won")
###SCORE FUNCTIONS###
func new_hole():
	print("New Hole")
	gameVars.par = levels[gameVars.map].holes[str(gameVars.hole)].par
	gameVars.scorecard.append(gameVars.currentScore) #add to card
	gameVars.currentScore = 0 #reset stroke
	gameVars.hole += 1
	baseScene.get_node(str(gameVars.hole)).get_node("Kill_Volume").get_node("Area").connect("oob",self,"on_oob")
	baseScene.get_node(str(gameVars.hole)).get_node("Golf_Hole_Volume").get_node("Hole_Area").connect("ball_in_hole",self,"on_game_won")
	var o = (levels[gameVars.map].holes[str(gameVars.hole)].origin)
	emit_signal("clearHud")
	emit_signal("move_ball",Vector3(o.x,o.y,o.z))

func hard_reset():
	gameVars.scorecard = []
	gameVars.currentScore = 0
	gameVars.hole = 0
	
###SIGNAL PROCESSING###
func on_oob():
	gameVars.currentScore += 1
	emit_signal("on_oob")
	print("Out Of Bounds!!!")

func on_game_won():
	print("In Hole!")
	emit_signal("on_won")
	t.set_wait_time(5) #const here is how long to wait before new hole
	t.start()
	yield(t,"timeout")
	new_hole()
