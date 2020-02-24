extends TextureButton

func _on_Play_pressed():
	get_parent().hide()
	get_parent().get_parent().get_node("HowMany").show()
