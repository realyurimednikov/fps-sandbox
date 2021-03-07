extends RayCast


class_name Interaction


var current_collider

const Interactable = preload("res://Interactable/Interactable.gd")


func _ready():
	get_tree().call_group("UI", "hide_interaction_text")


func _process(delta):
	var collider = get_collider()
	
	if is_colliding():
		if current_collider != collider:
			current_collider = collider
			if collider is Vehicle:
				var text = 'use vehicle'
				set_interaction_text(text)
			elif collider is Interactable:
				set_interaction_text(collider.get_interaction_text())
		
		if Input.is_action_just_pressed('interact'):
			if collider is Interactable:
				collider.interact()
				set_interaction_text(collider.get_interaction_text())
			elif collider is Vehicle:
				var vehicle = collider as Vehicle
				vehicle.use_vehicle()
	
	elif current_collider:
		current_collider = null
		get_tree().call_group("UI", "hide_interaction_text")


func set_interaction_text(text: String):
	var interact_key = OS.get_scancode_string(InputMap.get_action_list("interact")[0].scancode)
	var value = "Press " + str(interact_key) + " to " + text
	get_tree().call_group("UI", "show_interaction_text", value)


func disable():
	enabled = false


func enable():
	enabled = true
