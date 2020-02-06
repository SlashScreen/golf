extends TextureButton
#play button
export var map = "test"
func _on_Play_pressed():
	get_tree().get_root().get_node("Signal_Router").set_map(map)
	get_tree().get_root().get_node("Signal_Router").changeScene(get_node("/root/MainMenu"),"res://Levels/"+map+".tscn")
