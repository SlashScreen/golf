extends Node
#handles signals and variables

##INIT###
export var gameVars = {}
export var howManyPlayers = 1
onready var file = File.new()
var levels
onready var baseScene = get_parent().get_node("level")
onready var t = get_node("/root/DelayManager")
onready var ghostasset = load("res://Objects/Ghost_Ball.tscn")

signal move_ball(vec)
signal on_oob
signal on_won
signal clearHud
signal ghost(color,pos)
signal remove_ghost
signal switch(p)

func _ready():
	file.open("res://Levels/levels.json",File.READ)
	levels = JSON.parse(file.get_as_text()).get_result()
	file.close()
	hard_reset()
	connect("switch",self,"switch_players")
	get_parent().get_node("level").get_node("Golf_Ball_Obj").get_node("Ball").connect("newTurn",self,"on_new_turn")
###SCORE FUNCTIONS###
func new_hole():
	print("New Hole")
	disconnect_signal()
	gameVars.players[gameVars.currentPlayer].scorecard.append(gameVars.players[gameVars.currentPlayer].stroke) #add to card
	gameVars.players[gameVars.currentPlayer].stroke = 0 #reset stroke
	gameVars.players[gameVars.currentPlayer].hole += 1
	gameVars.players[gameVars.currentPlayer].location = levels[gameVars.map].holes[str(gameVars.players[gameVars.currentPlayer].hole)].origin
	switch_players(incrementPlayerCount())
	reconnect()
	var o = (levels[gameVars.map].holes[str(gameVars.players[gameVars.currentPlayer].hole)].origin)
	emit_signal("clearHud")
	emit_signal("move_ball",Vector3(o.x,o.y,o.z))

func hard_reset():
	gameVars.map = "test"
	gameVars.currentPlayer = 0
	gameVars.players = {}
	for i in range(howManyPlayers):
		var p = {}
		p.color = Color(50*i,50*i,50*i)
		p.scorecard = []
		p.stroke = 0
		p.hole = 0
		p.par = levels[gameVars.map].holes[str(p.hole)].par
		var o = (levels[gameVars.map].holes[str(p.hole)].origin)
		p.location = o
		gameVars.players[i] = p
	reconnect()

func disconnect_signal():
	baseScene.get_node(str(gameVars.players[gameVars.currentPlayer].hole)).get_node("Kill_Volume").get_node("Area").disconnect("oob",self,"on_oob")
	baseScene.get_node(str(gameVars.players[gameVars.currentPlayer].hole)).get_node("Golf_Hole_Volume").get_node("Hole_Area").disconnect("ball_in_hole",self,"on_game_won")

#TODO: function for switching players
func reconnect():
	#Connect
	baseScene.get_node(str(gameVars.players[gameVars.currentPlayer].hole)).get_node("Kill_Volume").get_node("Area").connect("oob",self,"on_oob")
	baseScene.get_node(str(gameVars.players[gameVars.currentPlayer].hole)).get_node("Golf_Hole_Volume").get_node("Hole_Area").connect("ball_in_hole",self,"on_game_won")

###SIGNAL PROCESSING###
func on_oob():
	gameVars.players[gameVars.currentPlayer].stroke += 1
	emit_signal("on_oob")
	print("Out Of Bounds!!!")

func on_game_won():
	print("In Hole!")
	emit_signal("on_won")
	t.set_wait_time(2) #const here is how long to wait before new hole
	t.start()
	yield(t,"timeout")
	new_hole()

func switch_players(player):
	var ghost = ghostasset.instance()
	disconnect_signal()
	#Ghost
	emit_signal("remove_ghost")
	get_parent().get_node("level").add_child(ghost)
	emit_signal("ghost",gameVars.players[gameVars.currentPlayer].color,gameVars.players[gameVars.currentPlayer].location)
	#Variable switch
	gameVars.currentPlayer = player
	#Move Ball
	emit_signal("move_ball",gameVars.players[gameVars.currentPlayer].location)
	reconnect()

func on_new_turn():
	switch_players(incrementPlayerCount())
###UTILITY##
func incrementPlayerCount():
	var i = gameVars.currentPlayer
	i += 1
	if i > howManyPlayers-1:
		i = 0
	return i
