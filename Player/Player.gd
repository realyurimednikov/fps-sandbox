extends KinematicBody


export var speed = 15
export var acceleration = 5
export var gravity = 0.98
export var jump_power = 20
export var mouse_sensetivity = 0.3


onready var head = $Head
onready var camera = $Head/Camera


var velocity = Vector3()
var camera_x_rotation = 0
var health = 100


func apply_gravity():
	velocity.y -= gravity


func _physics_process(delta):
	var direction = Vector3()
	var head_basis = head.global_transform.basis
	
	if Input.is_action_pressed("move_forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += head_basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("move_right"):
		direction += head_basis.x

	direction = direction.normalized()
	
	# gravity
	apply_gravity()
	
	# jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_power
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	
	velocity = move_and_slide(velocity, Vector3.UP)


func _input(event):
	if event is InputEventMouseMotion:
		
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensetivity))
		
		var x_delta = event.relative.y * mouse_sensetivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func update_ui():
	get_tree().call_group("UI", "update_health", health)

	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#just for test purposes
	if Input.is_action_pressed("damage_player"):
		health -= 1
		update_ui()
