extends Control

func _process(_delta):
	if Input.is_action_just_pressed("Menu"):
		if visible:
			get_tree().paused = false
			hide()
		else:
			show()
			get_tree().paused = true



func _on_menu_pressed():
	Transition.change_scene_to_file("res://Main_Menu.tscn")
