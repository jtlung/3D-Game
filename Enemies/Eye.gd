extends RigidBody3D
var beamFile = load("res://Enemies/eyebeam.tscn")
var health = 25

func shoot():
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	if Player and Player.gunEquipped:
		var beam = beamFile.instantiate()
		add_sibling(beam)
		beam.ignore = self
		beam.global_transform = $spawn.global_transform
		beam.linear_velocity = beam.global_transform.basis.z*-25
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var Player = get_node_or_null("/root/Game/Player_Container/Player")
	if Player:
		look_at(Player.global_position)
		
			

func _on_timer_timeout():
	shoot()
	
func kill():
	Global.addScore(50)
	queue_free()

func damage(dmg):
	health -= dmg
	if health <= 0:
		kill()
		


