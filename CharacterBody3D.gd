extends CharacterBody3D


const SPEED = 7.0
const JUMP_VELOCITY = 5.5
var health = 100
var hasGun = false
var gunEquipped = false
var beamFile = load("res://Player/guybeam.tscn")
var canShoot = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var pivot = $Pivot
@onready var camera := $Pivot/Camera3D
@onready var gun := $Guy/Armature/Skeleton3D/Hand/raygun
@onready var hpBar = get_node_or_null("/root/Game/UI/hpBar")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			pivot.rotate_y(-event.relative.x*.005)
			camera.rotate_x(-event.relative.y*.005)
			camera.rotation.x = clamp(camera.rotation.x,-PI/2,PI/2)
			$Guy.rotation.y = pivot.rotation.y-PI
			
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("Interact"):
		Global.interact(self)
	if Input.is_action_just_pressed("Shoot") and hasGun and gunEquipped:
		shoot()
	if Input.is_action_just_pressed("Equip") and hasGun:
		gunEquipped = not gunEquipped
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		$jump.play()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var animTree = $Guy/AnimationTree
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = ($Pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var icon = get_node_or_null("/root/Game/UI/gunIcon")
	if gunEquipped:
		gun.show()
		icon.modulate = Color(1,1,1)
		var tween = get_tree().create_tween()
		tween.tween_property(animTree,"parameters/holdBlend/blend_amount",1, .25)
	else:
		gun.hide()
		icon.modulate = Color(0,0,0)
		var tween = get_tree().create_tween()
		tween.tween_property(animTree,"parameters/holdBlend/blend_amount",0, .25)

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		var tween = get_tree().create_tween()
		tween.tween_property(animTree,"parameters/walkBlend/blend_amount",1, .25)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		var tween = get_tree().create_tween()
		tween.tween_property(animTree,"parameters/walkBlend/blend_amount",0, .1)
	move_and_slide()
	


func kill():
	Global.state = 1
	Transition.change_scene_to_file("res://Main_Menu.tscn")
	
func _ready():
	hpBar.value = health

func damage(dmg):
	health -= dmg
	hpBar.value = health
	if health <= 0:
		kill()
		
func shoot():
	if canShoot:
		canShoot = false
		$laser.play()
		$gunCD.start()
		var beam = beamFile.instantiate()
		add_sibling(beam)
		beam.ignore = self
		beam.global_position = gun.get_child(0).global_position
		beam.global_transform.basis = camera.global_transform.basis
		beam.linear_velocity = beam.global_transform.basis.z*-100


func _on_gun_cd_timeout():
	canShoot = true
