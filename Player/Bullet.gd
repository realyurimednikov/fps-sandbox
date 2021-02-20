extends RigidBody


const SPEED = 10
const DAMAGE = 25

var shoot = false

func _ready():
	set_as_toplevel(true)


func _physics_process(delta):
	if shoot:
		apply_impulse(transform.basis.z, -transform.basis.z)

func _on_Area_body_entered(body):
	if body.is_in_group('Enemies'):
		body.damage(DAMAGE)
	queue_free()
