extends RayCast


var current_collider

const Interactable = preload("res://Interactable/Interactable.gd")


func _ready():
	get_tree().call_group("UI", "hide_interaction_text")


func _process(delta):
	var collider = get_collider()
	
	if is_colliding() and collider is Interactable:
		if current_collider != collider:
			current_collider = collider
			set_interaction_text(collider.get_interaction_text())
		
		if Input.is_action_just_pressed('interact'):
			collider.interact()
			set_interaction_text(collider.get_interaction_text())
	
	elif current_collider:
		current_collider = null
		get_tree().call_group("UI", "hide_interaction_text")


func set_interaction_text(text):
	var interact_key = OS.get_scancode_string(InputMap.get_action_list("interact")[0].scancode)
	var value = "Press " + str(interact_key) + " to " + text
	get_tree().call_group("UI", "show_interaction_text", value)
#	if !text:
#		get_tree().call_group("UI", "hide_interaction_text")
#	else:
#		var interact_key = OS.get_scancode_string(InputMap.get_action_list("interact")[0].scancode)
#		var value = "Press " + str(interact_key) + " to " + text
#		get_tree().call_group("UI", "show_interaction_text", value)
