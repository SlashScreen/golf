extends Spatial

signal followCam(b)
signal holeCam
signal beginFollow

func begin():
	emit_signal("followCam",true)
	emit_signal("beginFollow")

func _on_Campoint_finished():
	emit_signal("followCam",false)
	emit_signal("beginFollow")

func _on_holecam_holeFinished():
	get_node("/root/Signal_Router").camFinished()
