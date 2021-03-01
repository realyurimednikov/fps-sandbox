extends RigidBody


var damage = 25
var shoot = false
var speed = 10

func _ready():
	set_as_toplevel(true)


func set_damage(value):
	damage = value
	

func set_speed(value):
	speed = value


func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * speed)


func _on_Area_body_entered(body):
	if body.is_in_group('Enemies'):
		body.damage(damage)
	elif body.is_in_group('Destroyables'):
		body.destroy_object()
	elif body.is_in_group('Player'):
		body.damage_player(damage)
	queue_free()
