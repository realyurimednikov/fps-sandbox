extends StaticBody


func damage(x):
	queue_free()


func _ready():
	add_to_group('Damageable')
