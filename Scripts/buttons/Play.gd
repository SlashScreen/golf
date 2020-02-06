extends TextureButton
#play button
func _on_Play_pressed():
	get_tree().get_root().get_node("Signal_Router").set_map("test")
	get_tree().get_root().get_node("Signal_Router").changeScene(get_node("/root/MainMenu"),"res://Levels/test_level.tscn")
