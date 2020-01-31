extends RigidBody
#Golf_Ball.gd
export var STATE = "still"
var should_move = false
var nextLocation = Vector3(0,0,0)
var lastState
var temp
var fromHit = false
onready var game_vars = get_node("/root/Signal_Router").gameVars
signal newTurn

func _ready():
	#Load textures and things later
	print("ball getting ready!")
	get_tree().get_root().get_node("Signal_Router").connect("move_ball",self,"_on_move_ball")
	get_tree().get_root().get_node("Signal_Router").connect("on_oob",self,"_on_oob")
	change_color(0)

func _process(delta):
	#TODO: make less finicky.
	if is_sleeping(): #get_linear_velocity().length() <= .01:
		STATE = "still"
	else:
		STATE = "moving"
	
	if fromHit and lastState == "moving" and STATE == "still":
		game_vars.players[game_vars.currentPlayer].location = get_transform().origin
		print("Set Saved location to " + str(game_vars.players[game_vars.currentPlayer].location) + ". World location is " + str(get_transform().origin))
		print("current location: " +str(game_vars.players[game_vars.currentPlayer].location)+str(get_transform().origin))
		emit_signal("newTurn")
		fromHit = false
	#print(str(get_transform().origin))
	#print(str(game_vars.players[game_vars.currentPlayer].location))
	lastState = STATE
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

func _integrate_forces(state): #Reset
	if should_move:
		print("moving from integrate " + str(nextLocation) + "; Current saved location is " + str(game_vars.players[game_vars.currentPlayer].location))
		should_move = false
		set_linear_velocity(Vector3(0,0,0)) #Make it stop moving
		set_angular_velocity(Vector3(0,0,0)) #Make it stop rotating
		state.transform.origin = to_vec(nextLocation)
		print("Integrated forces, now "+str(state.transform.origin))

func change_color(p):
	get_node("Ballmesh").get_surface_material(0).set_shader_param("Color",game_vars.players[p].color)

func reset_variables(p):
	fromHit = false
	get_node("Arrow").last_pos = game_vars.players[p].location

func get_ball_transform():
	return get_transform()

func to_vec(dict):
	return Vector3(dict.x,dict.y,dict.z)
