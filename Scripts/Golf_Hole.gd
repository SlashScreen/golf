extends Area

signal ball_in_hole

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_area_shape_entered(area_id, area, area_shape, self_shape):
	emit_signal("ball_in_hole")
	print("In hole!")
