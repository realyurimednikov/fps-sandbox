extends KinematicBody


class_name Vehicle

export var speed: float = 50
export var acceleration: float = 15
export var is_activated: bool = false


onready var camera = $"./CameraPivot/SpringArm/Camera"
onready var camera_pivot = $"./CameraPivot"

export(float, 0.5, 1) var mouse_sensetivity: float = 0.3
export(float, -90, 0) var min_pitch: float = -90
export(float, 0, 90) var max_pitch: float = 90


var velocity: Vector3


func use_vehicle():
	print('Use vehicle')
	is_activated = true
	camera.current = true
	do_on_embark()
	get_tree().call_group('Player', 'disable_player')
	get_tree().call_group('UI', 'activate_vehicle_ui', true)


func drop_vehicle():
	print('Drop vehicle')
	is_activated = false
	camera.current = false
	do_on_disembark()
	get_tree().call_group('Player', 'enable_player')
	get_tree().call_group('UI', 'activate_vehicle_ui', false)
#	get_tree().call_group('Player', 'update_player_position', transform.origin)
	

func _physics_process(delta):
	if is_activated:
		if Input.is_action_just_pressed("interact"):
			drop_vehicle()
		do_movement(delta)
		
func do_on_embark():
	pass


func do_on_disembark():
	pass


func do_movement(delta):
	var direction = Vector3()
		
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
#		if Input.is_action_pressed("move_left"):
#			direction -= transform.basis.x
#		elif Input.is_action_pressed("move_right"):
#			direction += transform.basis.x
		
		
	direction = direction.normalized()
		
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)


#func _input(event):
#	if is_activated and event is InputEventMouseMotion:
#		rotation_degrees.y -= event.relative.x * mouse_sensetivity
#		camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensetivity
#		camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)
