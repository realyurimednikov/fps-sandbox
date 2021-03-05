extends Spatial

class_name HealthBox


export var recharge:float = 10


func _on_Area_body_entered(body):
	if body.is_in_group('Player'):
		var player = body as Player
		var player_health = player.health
		if player_health < 100:
			body.recharge_health(recharge)
			queue_free()
