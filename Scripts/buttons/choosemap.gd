extends TextureButton

func _on_Choose_map_pressed():
	get_parent().hide()
	get_parent().get_parent().get_node("MapSelect").show()
