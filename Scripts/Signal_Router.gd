extends Node
#handles signals and variables

##INIT###
export var gameVars = {}
export var howManyPlayers = 1
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
	hard_reset()
###SCORE FUNCTIONS###
func new_hole():
	print("New Hole")
	gameVars.players[gameVars.currentPlayer].scorecard.append(gameVars.players[gameVars.currentPlayer].stroke) #add to card
	gameVars.players[gameVars.currentPlayer].stroke = 0 #reset stroke
	gameVars.players[gameVars.currentPlayer].hole += 1
	gameVars.par = levels[gameVars.map].holes[str(gameVars.players[gameVars.currentPlayer].hole)].par
	baseScene.get_node(str(gameVars.players[gameVars.currentPlayer].hole)).get_node("Kill_Volume").get_node("Area").connect("oob",self,"on_oob")
	baseScene.get_node(str(gameVars.players[gameVars.currentPlayer].hole)).get_node("Golf_Hole_Volume").get_node("Hole_Area").connect("ball_in_hole",self,"on_game_won")
	var o = (levels[gameVars.map].holes[str(gameVars.players[gameVars.currentPlayer].hole)].origin)
	emit_signal("clearHud")
	emit_signal("move_ball",Vector3(o.x,o.y,o.z))

func hard_reset():
	gameVars.map = "test"
	gameVars.currentPlayer = 0
	gameVars.players = {}
	for i in range(howManyPlayers):
		var p = {}
		p.location = Vector3()
		p.color = Color()
		p.scorecard = []
		p.stroke = 0
		p.hole = 0
		p.par = levels[gameVars.map].holes[str(p.hole)].par
		gameVars.players[i] = p
	print(str(gameVars.players))
	baseScene.get_node(str(gameVars.players[gameVars.currentPlayer].hole)).get_node("Kill_Volume").get_node("Area").connect("oob",self,"on_oob")
	baseScene.get_node(str(gameVars.players[gameVars.currentPlayer].hole)).get_node("Golf_Hole_Volume").get_node("Hole_Area").connect("ball_in_hole",self,"on_game_won")

#TODO: function for switching players

###SIGNAL PROCESSING###
func on_oob():
	gameVars.players[gameVars.currentPlayer].stroke += 1
	emit_signal("on_oob")
	print("Out Of Bounds!!!")

func on_game_won():
	print("In Hole!")
	emit_signal("on_won")
	t.set_wait_time(5) #const here is how long to wait before new hole
	t.start()
	yield(t,"timeout")
	new_hole()
