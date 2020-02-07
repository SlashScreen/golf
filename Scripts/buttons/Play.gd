extends Button
#play button
export var map = "test"
var last_state = false
signal mouse_hover(t,m)
func _on_Play_pressed():
	get_tree().get_root().get_node("Signal_Router").set_map(map)
	get_tree().get_root().get_node("Signal_Router").changeScene(get_node("/root/MainMenu"),"res://Levels/"+map+".tscn")

func _process(delta):
	if is_hovered() and last_state == false:
		emit_signal("mouse_hover",true,map)
	else:
		emit_signal("mouse_hover",false,map)
	last_state = is_hovered()
