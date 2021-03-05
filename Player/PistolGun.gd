extends Weapon


class_name PistolGun


onready var animation_player =  $AnimationPlayer


func do_on_shoot():
	animation_player.play("FireAnimation")
