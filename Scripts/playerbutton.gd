extends Button

export var p = 1

func _on_pressed():
	get_tree().get_root().get_node("Signal_Router").howManyPlayers = p
	get_parent().get_parent().get_node("Customizescreen/Customize").loadplayers()
	get_parent().hide()
	get_parent().get_parent().get_node("Customizescreen").show()
