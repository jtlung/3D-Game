extends Node3D



func _on_area_3d_body_entered(body):
	if body.name == "Player" and Global.itemFlags.button == false and get_node("Red"):
		Global.itemFlags.button = true
		$text.show()


func _on_area_3d_body_exited(body):
	if body.name == "Player" and get_node("Red"):
		Global.itemFlags.button = false
		$text.hide()
