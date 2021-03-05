extends RigidBody


class_name Bullet


var damage: float = 25
var shoot: bool = false
var speed:float = 10

func _ready():
	set_as_toplevel(true)


func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z * speed)


func _on_Area_body_entered(body):
	if body.is_in_group('Damageable'):
		if body.has_method('damage'):
			body.damage(damage)
	queue_free()
