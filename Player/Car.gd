extends Vehicle


class_name Car

export var gravity: float = -10
export var wheel_base: float = 0.5
export var steering_limit: float = 5 
export var engine_power: float = 100
export var braking: float = -9.0
export var friction: float = -0.5
export var drag: float = -2.0
export var max_speed_reverse: float = 30

var car_acceleration: Vector3 = Vector3.ZERO
var steer_angle: float = 0.0 


func handle_input():
	var turning = Input.get_action_strength("move_left")
	turning -= Input.get_action_strength("move_right")
	
	steer_angle = turning * deg2rad(steering_limit)
	
	car_acceleration = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		car_acceleration = -transform.basis.z * engine_power
	if Input.is_action_pressed("move_backward"):
		car_acceleration = -transform.basis.z * braking
	


func handle_friction(delta):
	if velocity.length() < 0.2 and car_acceleration.length() == 0:
		velocity.x = 0
		velocity.z = 0
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	car_acceleration += drag_force + friction_force
	

func handle_steering(delta):
	var rear_wheel = transform.origin + transform.basis.z * wheel_base / 2.0
	var front_wheel = transform.origin - transform.basis.z * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(transform.basis.y, steer_angle) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)
	var d = new_heading.dot(velocity.normalized())
	
	if d > 0:
		velocity = new_heading * velocity.length()
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)

	look_at(transform.origin + new_heading, transform.basis.y)	


func do_movement(delta):
	if is_on_floor():
		handle_input()
		handle_friction(delta)
		handle_steering(delta)
	car_acceleration.y = gravity
	velocity += car_acceleration * delta
	velocity = move_and_slide_with_snap(velocity, -transform.basis.y, Vector3.UP, true)
