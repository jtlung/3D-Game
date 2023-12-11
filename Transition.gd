extends CanvasLayer

func change_scene_to_file(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	get_tree().paused = false
	$AnimationPlayer.play_backwards("dissolve")
