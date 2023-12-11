extends RigidBody3D
var ignore = null


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(3).timeout
	queue_free()
	
	

func _on_hit_box_body_entered(body):
	if body.has_method("damage") and body != ignore:
		print(body.name)
		body.damage(25)
		queue_free()
	
