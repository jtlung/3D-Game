extends Node
var state = 0
var score = 0
var itemFlags = {
	gun = false,
	button = false,
	talk = false
}
@onready var texture = preload("res://Assets/Items/button_Button.png")
const Balloon = preload("res://NPC/realTalk.tscn")

func addScore(num):
	score+=num
	var scoreUI = get_node_or_null("/root/Game/UI/score")
	if scoreUI:
		scoreUI.text = "SCORE: "+ str(score)

func interact(plr):
	if itemFlags.gun:
		plr.hasGun = true
		plr.gunEquipped = true
		var node = get_node_or_null("/root/Game/Interactibles/gunPickup")
		var node2 = get_node_or_null("/root/Game/UI/gunIcon")
		if node2:
			node2.show()
		if node:
			node.queue_free()
	if itemFlags.button :
		var node = get_node_or_null("/root/Game/Interactibles/button")
		if node and node.get_node("Red"):
			itemFlags.button = false
			node.get_node("text").hide()
			node.get_node("Cube").hide()
			node.get_node("Cube2").show()
			node.get_node("Red").queue_free()
	if itemFlags.talk:
		var balloon = Balloon.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(load("res://NPC/chat.dialogue"), "main")
