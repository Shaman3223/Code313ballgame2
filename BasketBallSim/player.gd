extends CharacterBody3D

# Movement settings
const SPEED = 5
const JUMP_VELOCITY = 4.5
const ROTATE_SPEED = 0.005  

# Camera settings
var mouse_sensitivity = 0.002
var min_pitch = -3  # About -85 degrees in radians
var max_pitch = 3   # About 85 degrees in radians
var camera_pitch = 0.0

var ismouseCaptured: bool = true

var hasball = true

@onready var camera = $Camera3D  # Assuming you have a Camera3D child node

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Horizontal rotation (turning left/right)
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Vertical rotation (looking up/down)
		camera_pitch += event.relative.y * mouse_sensitivity
		camera_pitch = clamp(camera_pitch, min_pitch, max_pitch)
		camera.rotation.x = -camera_pitch/3

func toggleMouseMode():
	
	ismouseCaptured = !ismouseCaptured
	if ismouseCaptured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	if Input.is_action_just_pressed("ui_cancel"):
		toggleMouseMode()
	
	if Input.is_key_pressed(KEY_X):
		shootball(direction)
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	if direction:
		var sinvers: float = sin(rotation.y) * direction.z * SPEED
		var cosvers: float = cos(rotation.y) * direction.z * SPEED
		
		velocity.x = move_toward(sinvers, sinvers * 1.5, 10)
		velocity.z = move_toward(cosvers, cosvers * 1.5, 10)
		
		rotation.y += direction.x * ROTATE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func shootball(direction: Vector3):
	if !hasball:
		return
	var ball = load("res://basketball.tscn").instantiate()
	
	
	get_parent().add_child(ball)
	
	ball.position.z = global_position.z
	ball.position.x = global_position.x
	
	
	ball.shoot(sin(rotation.y) * direction.z * SPEED,cos(rotation.y) * direction.z * SPEED, 9.0 , 1.0, 4.0)
	
	hasball = false
