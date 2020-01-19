extends RigidBody
#Golf_Ball.gd
export var STATE = "still"
var should_move = false
var nextLocation = Vector3(0,0,0)
var lastState
var fromHit = false
onready var game_vars = get_node("/root/Signal_Router").gameVars
signal newTurn

func _ready():
	#Load textures and things later
	get_tree().get_root().get_node("Signal_Router").connect("move_ball",self,"_on_move_ball")
	get_tree().get_root().get_node("Signal_Router").connect("on_oob",self,"_on_oob")
	get_tree().get_root().get_node("Signal_Router").connect("switch",self,"switch")
	switch(0)

func _process(delta):
	#TODO: make less finicky.
	if is_sleeping(): #get_linear_velocity().length() <= .01:
		STATE = "still"
	else:
		STATE = "moving"
	
	if fromHit and lastState == "moving" and STATE == "still":
		game_vars.players[game_vars.currentPlayer].location = get_translation()
		print(str(game_vars.currentPlayer)+str(game_vars.players[game_vars.currentPlayer].location))
		emit_signal("newTurn")
		fromHit = false
	
	lastState = STATE

func _on_oob(): #signal
	should_move = true
	fromHit = false
	nextLocation = get_node("Arrow").last_pos

func _on_move_ball(vec):
	print("move function")
	should_move = true
	nextLocation = Vector3(vec.x,vec.y,vec.z)
	set_sleeping(false)

func _integrate_forces(state): #Reset
	if should_move:
		print("moving from integrate " + str(nextLocation))
		should_move = false
		set_linear_velocity(Vector3(0,0,0)) #Make it stop moving
		set_angular_velocity(Vector3(0,0,0)) #Make it stop rotating
		state.transform.origin = nextLocation

func switch(p):
	fromHit = false
	print("switching from golf node")
	print(str(p)+str(game_vars.players[p].location))
	_on_move_ball(game_vars.players[p].location)
	get_node("Ballmesh").get_surface_material(0).set_shader_param("Color",game_vars.players[p].color)
