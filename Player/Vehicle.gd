extends KinematicBody


class_name Vehicle

export var speed: float = 50
export var acceleration: float = 15
export var is_activated: bool = false


var velocity: Vector3


func use_vehicle():
	print('Use vehicle')
	is_activated = true
	do_on_embark()
	get_tree().call_group('Player', 'disable_player')
	get_tree().call_group('UI', 'activate_vehicle_ui', true)


func drop_vehicle():
	print('Drop vehicle')
	is_activated = false
	do_on_disembark()
	get_tree().call_group('Player', 'enable_player')
	get_tree().call_group('UI', 'activate_vehicle_ui', false)
#	get_tree().call_group('Player', 'update_player_position', transform.origin)
	

func _physics_process(delta):
	if is_activated:
		if Input.is_action_just_pressed("interact"):
			drop_vehicle()
		
			#move
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
		
#		var vehicle_loc = transform.origin
#		get_tree().call_group('Player', 'update_player_position', vehicle_loc)


func do_on_embark():
	pass


func do_on_disembark():
	pass
