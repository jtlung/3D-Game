extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var pivot = $Pivot
@onready var camera := $Pivot/Camera3D

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

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var animTree = $Guy/AnimationTree
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = ($Pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var walkTween = get_tree().create_tween()
	if true:
		animTree["parameters/holdBlend/blend_amount"] = 1
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		walkTween.tween_property(animTree,"parameters/walkBlend/blend_amount",1, .35)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		walkTween.tween_property(animTree,"parameters/walkBlend/blend_amount",0, .15)
	move_and_slide()
