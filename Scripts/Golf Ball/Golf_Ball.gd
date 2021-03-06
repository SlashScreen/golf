extends RigidBody
#Script for golf ball
#vars
export var STATE = "still"
onready var game_vars = get_node("/root/Signal_Router").gameVars
var should_move = false
var nextLocation = Vector3(0,0,0)
var lastState
var temp
var fromHit = false
#signal
signal newTurn

func _ready():
	#Load textures and things later
	print("ball getting ready!")
	#connect
	get_tree().get_root().get_node("Signal_Router").connect("move_ball",self,"_on_move_ball")
	get_tree().get_root().get_node("Signal_Router").connect("on_oob",self,"_on_oob")
	#change colors to player 0
	change_color(0)

func _process(delta):
	#TODO: make less finicky.
	#figures out if it's done moving
	if is_sleeping(): #get_linear_velocity().length() <= .01:
		STATE = "still"
	else:
		STATE = "moving"
	
	if fromHit and lastState == "moving" and STATE == "still":
		#if it's still and was made moving from a hit then it is done moving
		game_vars.players[game_vars.currentPlayer].location = get_transform().origin #set location to return to later
		#emit new turn
		emit_signal("newTurn")
		fromHit = false #no longer from a kid
	#print(str(get_transform().origin))
	#print(str(game_vars.players[game_vars.currentPlayer].location))
	lastState = STATE #for comparison
	#var o = game_vars.players[game_vars.currentPlayer].location
	#if temp != Vector3(o.x,o.y,o.z):
	#	print("Last saved location was " + str(temp)+", was set to " + str(game_vars.players[game_vars.currentPlayer].location))
	#	print("But, the current world space is "+str(get_transform().origin))
	#temp = Vector3(o.x,o.y,o.z)

func _on_oob(): #signal
	should_move = true
	fromHit = false
	nextLocation = get_node("Arrow").last_pos

func _on_move_ball(vec):
	print("move function")
	should_move = true
	nextLocation = to_vec(vec)
	set_sleeping(false)

func _integrate_forces(state): #Move ball to nextLocation
	if should_move: #if it needs to move
		print("moving from integrate " + str(nextLocation) + "; Current saved location is " + str(game_vars.players[game_vars.currentPlayer].location))
		should_move = false #no longer needs to move
		set_linear_velocity(Vector3(0,0,0)) #Make it stop moving
		set_angular_velocity(Vector3(0,0,0)) #Make it stop rotating
		state.transform.origin = to_vec(nextLocation) #move it
		print("Integrated forces, now "+str(state.transform.origin))

func change_color(p): #change color
	get_node("Ballmesh").get_surface_material(0).set_shader_param("Color",game_vars.players[p].color)

func reset_variables(p): #self descriptive
	fromHit = false
	get_node("Arrow").last_pos = game_vars.players[p].location

func get_ball_transform(): #get transform
	return get_transform()

func to_vec(dict): #convers dict to vec
	return Vector3(dict.x,dict.y,dict.z)
