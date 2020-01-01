extends Area

signal ball_in_hole

func _ready():
	pass # Replace with function body.

func _on_Area_area_shape_entered(area_id, area, area_shape, self_shape):
	emit_signal("ball_in_hole")
	print("In hole!")
