extends Control
var states = ["3D GAME", "GAME OVER", "YOU WON"]

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Label.text = states[Global.state]
	if Global.state != 0:
		$Score.show()
		$Score.text = "SCORE: " + str(Global.score)
	else:
		$Score.hide()
	Global.score = 0
	Global.state = 0

func _on_play_pressed():
	Transition.change_scene_to_file("res://game.tscn")


func _on_quit_pressed():
	get_tree().quit()
