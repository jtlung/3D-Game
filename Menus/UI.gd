extends Control

func _ready():
	$score.text = "SCORE: "+str(Global.score)
