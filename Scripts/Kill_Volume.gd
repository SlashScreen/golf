extends Area

onready var router = get_node("/root/Signal_Router")

func _on_Area_body_entered(body): #when ball enters hole
	router.on_oob()
