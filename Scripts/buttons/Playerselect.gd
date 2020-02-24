extends GridContainer

onready var l = load("res://Objects/Playerbutton.tscn")

func loadplayers():
	for i in range(get_tree().get_root().get_node("Signal_Router").howManyPlayers):
		var p = l.instance()
		add_child(p)
