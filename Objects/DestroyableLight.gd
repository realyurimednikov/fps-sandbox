extends StaticBody


class_name DestroyableLight

func damage(x):
	queue_free()


func _ready():
	add_to_group('Damageable')
