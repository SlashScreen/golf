extends Area

signal oob

func _ready():
	pass

func _on_Area_body_entered(body): #when ball enters hole
	emit_signal("oob")
