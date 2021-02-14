extends KinematicBody


var health = 100


func damage(x):
	if health > 0:
		health -= x
	else:
		queue_free()
