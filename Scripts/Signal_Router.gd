extends Node
#handles signals and variables

##INIT###
export var gameVars = {}
export var howManyPlayers = 2
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
	get_parent().get_node("level").get_node("Golf_Ball_Obj").connect("newTurn",self,"on_new_turn")
###SCORE FUNCTIONS###
func new_hole():
	print("\nNEW HOLE\n")
	gameVars.players[gameVars.currentPlayer].scorecard.append(gameVars.players[gameVars.currentPlayer].stroke) #add to card
	gameVars.players[gameVars.currentPlayer].stroke = 0 #reset stroke
	gameVars.players[gameVars.currentPlayer].hole += 1
	gameVars.players[gameVars.currentPlayer].location = levels[gameVars.map].holes[str(gameVars.players[gameVars.currentPlayer].hole)].origin
	get_parent().get_node("level").get_node("Golf_Ball_Obj").get_node("Arrow").last_pos = levels[gameVars.map].holes[str(gameVars.players[gameVars.currentPlayer].hole)].origin
	gameVars.players[gameVars.currentPlayer].ghost.move()
	if howManyPlayers > 1:
		switch_players(incrementPlayerCount())
	else:
		emit_signal("move_ball",gameVars.players[gameVars.currentPlayer].location)
	emit_signal("clearHud")

func hard_reset():
	gameVars.map = "test"
	gameVars.currentPlayer = 0
	gameVars.players = {}
	for i in range(howManyPlayers):
		var p = {}
		var ghost = load("res://Objects/Ghost_Ball.tscn").instance()
		p.color = Color(.5*i,.5*i,.5*i) #NTS: ball color in 0-1, not 255
		p.scorecard = []
		p.stroke = 0
		p.hole = 0
		p.par = levels[gameVars.map].holes[str(p.hole)].par
		ghost.show = false
		ghost.color = p.color
		ghost.name = str(i)
		get_parent().get_node("level").get_node("Ghost_Balls").add_child(ghost)
		p.ghost = get_parent().get_node("level").get_node("Ghost_Balls").get_node(str(i))
		var o = (levels[gameVars.map].holes[str(p.hole)].origin)
		p.location = o
		gameVars.players[i] = p

###SIGNAL PROCESSING###
func on_oob():
	gameVars.players[gameVars.currentPlayer].stroke += 1
	emit_signal("on_oob")
	print("\nOOB\n")

func on_game_won():
	print("In Hole!")
	emit_signal("on_won")
	t.set_wait_time(2) #const here is how long to wait before new hole
	t.start()
	yield(t,"timeout")
	
	new_hole()

func switch_players(player):
	if howManyPlayers > 1:
		print("\nSWITCH to " + str(player) + "\n")
		var ball =  get_parent().get_node("level").get_node("Golf_Ball_Obj")
		#Ghost
		gameVars.players[gameVars.currentPlayer].ghost.show = true
		#Variable switch
		gameVars.currentPlayer = player
		#Move Ball
		
		emit_signal("move_ball",gameVars.players[gameVars.currentPlayer].location)
		#set vars
		ball.change_color(player)
		ball.reset_variables(player)
		gameVars.players[gameVars.currentPlayer].ghost.show = false
	#else:
		#emit_signal("move_ball",gameVars.players[gameVars.currentPlayer].location)

func on_new_turn():
	switch_players(incrementPlayerCount())
###UTILITY##
func incrementPlayerCount():
	var i = gameVars.currentPlayer
	i += 1
	if i > howManyPlayers-1:
		i = 0
	return i

func return_ball():
	return get_parent().get_node("level").get_node("Golf_Ball_Obj")