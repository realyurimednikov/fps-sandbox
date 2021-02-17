extends KinematicBody


onready var sphere = $MeshInstance


var health = 100
var target

func damage(x):
	if health > 0:
		health -= x
	else:
		queue_free()
		

func _process(delta):
	if target:
		look_at_player()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
		set_to_red()


func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		set_to_green()
	

func set_to_green():
	sphere.get_surface_material(0).set_albedo(Color(0, 1, 0))


func set_to_red():
	sphere.get_surface_material(0).set_albedo(Color(1, 0, 0))


func look_at_player():
	look_at(target.global_transform.origin, Vector3.UP)
