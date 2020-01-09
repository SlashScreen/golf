extends Particles

func _ready():
	get_tree().get_root().get_node("Signal_Router").connect("on_won",self,"_won")

func _won():
	restart()
	print("Confetti!!!")
