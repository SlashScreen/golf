extends MeshInstance

func _ready():
	get_tree().get_root().get_node("Signal_Router").connect("ghost",self,"_on_ghost_ball")
	get_tree().get_root().get_node("Signal_Router").connect("remove_ghost",self,"_on_remove")

func _on_ghost_ball(color,pos): #Sets shader color
	get_surface_material(0).set_shader_param("Color",color)
	set_translation(Vector3(pos.x,pos.y,pos.z))

func _on_remove(): #Removes ball
	queue_free()
