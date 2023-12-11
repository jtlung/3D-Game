extends Node3D
var won = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Enemies.get_child_count() <= 0 and not won:
		won = true
		get_tree().paused = true
		Global.state = 2
		Transition.change_scene_to_file("res://Main_Menu.tscn")
