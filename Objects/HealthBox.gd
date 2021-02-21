extends Spatial


export var recharge = 10



func _on_Area_body_entered(body):
	if body.is_in_group('Player'):
		var player_health = body.health
		if player_health < 100:
			body.recharge_health(recharge)
			queue_free()
