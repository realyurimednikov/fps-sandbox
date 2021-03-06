extends KinematicBody


class_name Player


export var speed: float = 15
export var acceleration: float = 5
export var gravity: float = 0.98
export var jump_power: float = 20
export var mouse_sensetivity: float = 0.3

export var sway_left: Vector3
export var sway_right: Vector3
export var sway_normal: Vector3

onready var head = $Head
onready var camera = $Head/FirstPersonCamera
onready var assault_rifle_gun = $Head/FirstPersonCamera/Hand/AssaultRifleGun
onready var pistol_gun = $Head/FirstPersonCamera/Hand/PistolGun
onready var third_person_camera = $ThirdPersonCamera
onready var hand = $Head/FirstPersonCamera/Hand
onready var active_weapon: Weapon

var velocity: Vector3
var mouse_mov: float
var is_active: bool = true

var sway_threshold: float = 5
var sway_lerp: float = 5
var camera_x_rotation: float = 0
var health: float = 100
var selected_weapon: float = 1
var is_first_person_camera_active: bool = true



func apply_gravity():
	velocity.y -= gravity


func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += jump_power

func _physics_process(delta):
	
	if is_active:
	
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
		
		# switch weapons
		switch_weapons()
		
		if Input.is_action_just_pressed("primary_fire"):
			if active_weapon.is_possible_shoot:
				active_weapon.shoot()
				
		if Input.is_action_pressed("reload"):
			active_weapon.reload()
		
		# switch weapons with two buttons (to test gamepad without gamepad):
		if Input.is_action_just_pressed("weapon_switch_up"):
			weapon_switch_up()
		elif Input.is_action_just_pressed("weapon_switch_down"):
			weapon_switch_down()
		
		# jump
		jump()
		
		velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
		
		velocity = move_and_slide(velocity, Vector3.UP)
		
		update_ui()


func _input(event):
	rotate_head(event)
	
	if event is InputEventMouseButton:
		
		# switch weapons
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				weapon_switch_up()
			elif event.button_index == BUTTON_WHEEL_DOWN:
				weapon_switch_down()
	
	#weapon sway
	if event is InputEventMouseMotion:
		mouse_mov = -event.relative.x

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group('Damageable')
	active_weapon = $Head/FirstPersonCamera/Hand/PistolGun


func update_ui():
	get_tree().call_group("UI", "update_health", health)
	if active_weapon != null:
		get_tree().call_group("UI", "update_ammo", active_weapon.current_ammo, active_weapon.clip_size)
		get_tree().call_group("UI", "update_ammo_type", active_weapon.weapon_name)
		if active_weapon.is_possible_shoot:
			get_tree().call_group("UI", "show_crosshair_active", true)
		else:
			get_tree().call_group("UI", "show_crosshair_active", false)


func rotate_head(event):
	if event is InputEventMouseMotion and is_first_person_camera_active:
		head.rotate_y(deg2rad(-event.relative.x * mouse_sensetivity))
		var x_delta = event.relative.y * mouse_sensetivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-x_delta))
			camera_x_rotation += x_delta


func switch_weapons():
	if Input.is_action_just_pressed("weapon_pistol"):
		selected_weapon = 1
		
	elif Input.is_action_just_pressed("weapon_rifle"):
		selected_weapon = 2
		
	
	if selected_weapon == 1:
		active_weapon = $Head/FirstPersonCamera/Hand/PistolGun
		pistol_gun.enable_gun()
		assault_rifle_gun.disable_gun()
	elif selected_weapon == 2:
		active_weapon = $Head/FirstPersonCamera/Hand/AssaultRifleGun
		pistol_gun.disable_gun()
		assault_rifle_gun.enable_gun()
	
	update_ui()


func switch_camera():
	if is_first_person_camera_active:
		is_first_person_camera_active = false
	else:
		is_first_person_camera_active = true
	
	camera.current = is_first_person_camera_active
	third_person_camera.current = !is_first_person_camera_active
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("camera_switch"):
		switch_camera()
		
	# weapon sway
	if mouse_mov != null:
		if mouse_mov > sway_threshold:
			hand.rotation = hand.rotation.linear_interpolate(sway_left, sway_lerp * delta)
		elif mouse_mov < -sway_threshold:
			hand.rotation = hand.rotation.linear_interpolate(sway_right, sway_lerp * delta)
		else:
			hand.rotation = hand.rotation.linear_interpolate(sway_normal, sway_lerp * delta)


func recharge_health(value: float):
	health += value
	update_ui()


func damage(damage: float):
	health -= damage
	update_ui()
	

func weapon_switch_up():
	if selected_weapon < 2:
		selected_weapon += 1
	else:
		selected_weapon = 1


func weapon_switch_down():
	if selected_weapon > 1:
		selected_weapon -= 1
	else:
		selected_weapon = 2


func enable_player():
	is_active = true
	visible = true
	camera.current = true


func disable_player():
	is_active = false
	visible = false
	camera.current = false


func update_player_position(position):
	transform.origin = position
