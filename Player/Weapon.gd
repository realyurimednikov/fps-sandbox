extends Spatial

class_name Weapon


export var fire_rate: float = 0.5
export var clip_size: float = 5
export var reload_rate: float = 1
export var damage_value: float = 25
export var is_active: bool = false
export var shoot_speed: float = 5
export var fire_distance: float = -30
export var weapon_name: String

var current_ammo: float = 0 
var can_fire: bool = true
var reloading : bool = false
var is_possible_shoot: bool = false

onready var raycast = $"./RayCast"
onready var muzzle = $"./Muzzle"


onready var bullet = preload("res://Player/Bullet.tscn")

func update_ui():
	get_tree().call_group("UI", "update_ammo", current_ammo, clip_size)


func _ready():
	current_ammo = clip_size
	raycast.cast_to.z = fire_distance


func fire():
	if is_possible_shoot:
		var b = bullet.instance()
		muzzle.add_child(b)
		b.look_at(raycast.get_collision_point(), Vector3.UP)
		b.damage = damage_value
		b.speed = shoot_speed
		b.shoot = true

func reload():
	do_on_reload()
	is_possible_shoot = false
	reloading = true
	yield(get_tree().create_timer(reload_rate), "timeout")
	current_ammo = clip_size
	reloading = false
	is_possible_shoot = true


func shoot():
	if can_fire:
		if current_ammo > 0 and not reloading:
			can_fire = false
			current_ammo -= 1
			fire()
			do_on_shoot()
			yield(get_tree().create_timer(fire_rate), "timeout")
			can_fire = true
		elif not reloading:
			reload()
			
func do_on_shoot():
	pass


func do_on_reload():
	pass

func _physics_process(delta):
	if is_active:
		if raycast.is_colliding():
			is_possible_shoot = true
	else:
		is_possible_shoot = false


func enable_gun():
	is_active = true
	visible = true

func disable_gun():
	is_active = false
	visible = false
	is_possible_shoot = false
