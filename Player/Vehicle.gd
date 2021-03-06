extends KinematicBody


class_name Vehicle


export var is_activated: bool = false


func use_vehicle():
	print('Use vehicle')
	is_activated = true


func drop_vehicle():
	print('Drop vehicle')
	is_activated = false
	

func _physics_process(delta):
	if is_activated:
		print('is active')
