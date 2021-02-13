extends Node

class_name Interactable

func get_interaction_text():
	return 'interact'


func interact():
	print('interact with ' + name)
