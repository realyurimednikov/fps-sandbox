extends Node

class_name Weapon


export var fire_rate = 0.5
export var clip_size = 5
export var reload_rate = 1


var current_ammo = 0 
var can_fire = true
var reloading = false


onready var raycast = $"../Head/Camera/RayCast"


func update_ui():
	get_tree().call_group("UI", "update_ui", current_ammo, clip_size)


func _ready():
	current_ammo = clip_size
	update_ui()
	

func check_collision():
	if raycast.is_colliding():
		print('collide!')
		var col = raycast.get_collider()
		if col.is_in_group('Enemies'):
			print('Enemy!')
			col.queue_free()
			print('killed!' + col.name)


func _process(delta):
	if Input.is_action_just_pressed("primary_fire") and can_fire:
		if current_ammo > 0 and not reloading:
			
			print('Fire!')
			can_fire = false
			current_ammo -= 1
			check_collision()
			yield(get_tree().create_timer(fire_rate), "timeout")
		
			can_fire = true
			
		elif not reloading:
			
			reloading = true
			print('reloading...')
			
			yield(get_tree().create_timer(reload_rate), "timeout")
			
			current_ammo = clip_size
			print('reload complete')
			reloading = false
		
		update_ui()		
