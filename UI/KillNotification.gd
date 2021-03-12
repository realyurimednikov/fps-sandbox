extends HBoxContainer


onready var timer = $NotificationVisibleTimer


func _ready():
	add_to_group('UI')


func show_kill_notification():
	visible = true
	if timer.is_stopped():
		timer.start()

func _on_NotificationVisibleTimer_timeout():
	visible = false
	timer.stop()
