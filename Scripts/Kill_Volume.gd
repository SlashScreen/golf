extends Area
#Note: Kill volume must always be under root
#signal oob
func _ready():
	pass
	#print(get_parent().name)
	#get_parent().get_parent().get_node("Golf_Ball_Obj").connect("oob",get_parent().get_parent().get_node("Golf_Ball_Obj"),"Spatial_on_oob")

func _on_Area_body_entered(body):
	print(body.name)
	body.reset()
	#emit_signal("oob")
