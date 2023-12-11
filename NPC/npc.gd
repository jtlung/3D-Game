extends CharacterBody3D



func _on_area_3d_body_entered(body):
	if body.name == "Player":
		Global.itemFlags.talk = true
		$text.show()


func _on_area_3d_body_exited(body):
	if body.name == "Player":
		Global.itemFlags.talk = false
		$text.hide()
