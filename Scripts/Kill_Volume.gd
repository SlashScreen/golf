extends Area
#Note: Kill volume must always be under root
signal oob

func _ready():
	pass

func _on_Area_body_entered(body):
	emit_signal("oob")
