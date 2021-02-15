extends Node

class_name Weapon


export var fire_rate = 0.5
export var clip_size = 5
export var reload_rate = 1
export var damage_value = 25


var current_ammo = 0 
var can_fire = true
var reloading = false


onready var raycast = $"../RayCast"
onready var animation_player = $"../AnimationPlayer"

func update_ui():
	get_tree().call_group("UI", "update_ui", current_ammo, clip_size)


func _ready():
	current_ammo = clip_size
	update_ui()
	

func fire():
	if raycast.is_colliding():
		var col = raycast.get_collider()
		if col.is_in_group('Enemies'):
			col.damage(damage_value)


func _process(delta):
	if Input.is_action_just_pressed("primary_fire") and can_fire:
		if current_ammo > 0 and not reloading:
			
			
			can_fire = false
			current_ammo -= 1
			if not animation_player.is_playing():
				fire()
			animation_player.play("FireAnimation")
			yield(get_tree().create_timer(fire_rate), "timeout")
		
			can_fire = true
			
			
		elif not reloading:
			
			animation_player.stop()
			
			reloading = true
			print('reloading...')
			
			yield(get_tree().create_timer(reload_rate), "timeout")
			
			current_ammo = clip_size
			print('reload complete')
			reloading = false

		else:
			animation_player.stop()
		
		update_ui()		
