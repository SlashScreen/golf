extends Area

onready var router = get_node("/root/Signal_Router")

func _on_Hole_Area_body_entered(body):
	router.on_game_won()
	print("In hole!")
