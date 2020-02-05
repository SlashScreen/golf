extends Node
#handles signals and variables

#vars
export var gameVars = {}
export var howManyPlayers = 2
onready var file = File.new()
onready var baseScene = null#
onready var t = get_node("/root/DelayManager")
var levels
#signals
signal move_ball(vec)
signal freeze(c)
signal msg(m)
signal on_oob
signal on_won
signal clearHud

func changeScene(orig,res): #switches World
	var s = load(res) #loads new world scene
	var scene = s.instance()
	
	orig.queue_free() #deletes old world variables
	
	loadit(scene) #loads new world
	
	get_parent().add_child(scene) #sets root scene to new world

func loadit(scene): #loads scene
	print("loading...")
	baseScene = scene #sets basescene
	#read hole json
	file.open("res://Levels/levels.json",File.READ)
	levels = JSON.parse(file.get_as_text()).get_result()
	file.close()
	#create new hole
	hard_reset()
	#connect
	scene.get_node("Golf_Ball_Obj").connect("newTurn",self,"on_new_turn")

func new_hole(): #sets up next home
	print("\nNEW HOLE\n")
	#sets gamevars stuff
	gameVars.players[gameVars.currentPlayer].scorecard.append(gameVars.players[gameVars.currentPlayer].stroke) #add to card
	gameVars.players[gameVars.currentPlayer].stroke = 0 #reset stroke
	gameVars.players[gameVars.currentPlayer].hole += 1 #next hole
	#TODO: detect end
	gameVars.players[gameVars.currentPlayer].location = levels[gameVars.map].holes[str(gameVars.players[gameVars.currentPlayer].hole)].origin #sets ball location to hole start
	baseScene.get_node("Golf_Ball_Obj").get_node("Arrow").last_pos = levels[gameVars.map].holes[str(gameVars.players[gameVars.currentPlayer].hole)].origin #sets ball lastlocation to hole start
	gameVars.players[gameVars.currentPlayer].ghost.move() #move ghost balls
	if howManyPlayers > 1: #if there's more than one player, change player
		switch_players(incrementPlayerCount())
	else:
		#or else, move ball. this is done in switch players but here its done without all the switching crap
		emit_signal("move_ball",gameVars.players[gameVars.currentPlayer].location)
	#clear victory screen
	emit_signal("clearHud")

func hard_reset():
	#inits new map
	gameVars.map = "test" #TODO: change this
	gameVars.currentPlayer = 0
	gameVars.players = {}
	#creates player objects
	for i in range(howManyPlayers):
		#variables
		var p = {}
		var ghost = load("res://Objects/Ghost_Ball.tscn").instance()
		#set up ball
		p.color = Color(.5*i,.5*i,.5*i) #NTS: ball color in 0-1, not 255
		p.scorecard = []
		p.stroke = 0
		p.hole = 0
		p.par = levels[gameVars.map].holes[str(p.hole)].par
		#set up ghost
		ghost.show = false
		ghost.color = p.color
		ghost.name = str(i)
		baseScene.get_node("Ghost_Balls").add_child(ghost)
		p.ghost = baseScene.get_node("Ghost_Balls").get_node(str(i))
		#possibly deprecated? set location to hole origin
		var o = (levels[gameVars.map].holes[str(p.hole)].origin)
		p.location = o
		#add to player list
		gameVars.players[i] = p

func on_oob(): #on out of bounds
	gameVars.players[gameVars.currentPlayer].stroke += 1 #increment stroke
	#freeze camera and set display message
	emit_signal("freeze",true)
	emit_signal("msg","Out of Bounds!")
	#delay 
	t.set_wait_time(1.5) #const here is how long to wait before unfreeze
	t.start()
	yield(t,"timeout")
	#unfreeze camera, clear message, move ball and all that
	emit_signal("freeze",false)
	emit_signal("clearHud")
	emit_signal("on_oob")
	
	print("\nOOB\n")

func on_game_won():
	print("In Hole!")
	#on one signal
	emit_signal("on_won")
	#timer
	t.set_wait_time(2) #const here is how long to wait before new hole
	t.start()
	yield(t,"timeout")
	#next hole
	new_hole()

func switch_players(player):
	if howManyPlayers > 1:
		print("\nSWITCH to " + str(player) + "\n")
		var ball =  baseScene.get_node("Golf_Ball_Obj")
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

func on_new_turn(): #when there is a new turn
	switch_players(incrementPlayerCount())

func incrementPlayerCount(): #increments player count up by 1, and loops if reaches end
	var i = gameVars.currentPlayer
	i += 1
	if i > howManyPlayers-1:
		i = 0
	return i

func return_ball(): #returns ball object
	return baseScene.get_node("Golf_Ball_Obj")
