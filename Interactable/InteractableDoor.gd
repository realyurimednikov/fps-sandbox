extends Interactable

onready var animation_player = $"./AnimationPlayer"


func get_interaction_text():
	return 'open the door'


func interact():
	animation_player.play('Open')
