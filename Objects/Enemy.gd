extends KinematicBody


export var speed = 15


onready var sphere = $MeshInstance
onready var gun = $Gun
onready var shoot_timer = $ShootTimer 
onready var viewport = $Sprite3D/Viewport
onready var health_bar_view = $Sprite3D
onready var health_bar_progress = $Sprite3D/Viewport/TextureProgress

onready var bullet = preload("res://Player/Bullet.tscn")


var health = 100
var target
var space_state


func _ready():
	space_state = get_world().direct_space_state
	var texture = viewport.get_texture()
	health_bar_view.texture = texture
	
func damage(x):
	if health > x:
		health -= x
		update_health_bar()
	else:
		queue_free()
		

func _physics_process(delta):
	if target:
		var result = space_state.intersect_ray(global_transform.origin, target.global_transform.origin)
		var collider = result.collider
		if collider.is_in_group("Player"):
			look_at_player()
			follow_player(delta)
			if shoot_timer.is_stopped():
				shoot_timer.start()
		else:
			set_to_green()
			shoot_timer.stop()


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		target = body
#		set_to_red()


func _on_Area_body_exited(body):
	if body.is_in_group("Player"):
		target = null
		shoot_timer.stop()
#		set_to_green()
	

func set_to_green():
	sphere.get_surface_material(0).set_albedo(Color(0, 1, 0))


func set_to_red():
	sphere.get_surface_material(0).set_albedo(Color(1, 0, 0))


func look_at_player():
	look_at(target.global_transform.origin, Vector3.UP)
	

func follow_player(delta):
	var direction = (target.transform.origin - transform.origin).normalized()
	move_and_slide(direction * speed * delta, Vector3.UP)


func shoot_to_player():
	print('Shoot!!!!!')
	var b = bullet.instance()
	gun.add_child(b)
	b.set_damage(10)
	b.shoot = true


func _on_ShootTimer_timeout():
	shoot_to_player()


func update_health_bar():
	health_bar_progress.value = health
