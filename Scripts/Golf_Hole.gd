extends Area

signal ball_in_hole

func _ready():
	pass # Replace with function body.

func _on_Hole_Area_body_entered(body):
	emit_signal("ball_in_hole")
	print("In hole!")
