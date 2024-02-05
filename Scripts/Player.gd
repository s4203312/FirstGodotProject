extends CharacterBody3D

@onready var head : Node3D = $Head
@onready var camera : Camera3D = $Head/Camera

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_sensitivity : float = 0.35
var moving_lerp_speed : float = 4.5
var stopping_lerp_speed : float = 5.0

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, moving_lerp_speed * delta)
		velocity.z = lerp(velocity.z, direction.z * SPEED, moving_lerp_speed * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, stopping_lerp_speed * delta)
		velocity.z = lerp(velocity.z, 0.0, stopping_lerp_speed * delta)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg_to_rad(-event.relative.x * look_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * look_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

