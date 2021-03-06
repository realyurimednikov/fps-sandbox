extends Vehicle


onready var camera = $CameraPivot/SpringArm/Camera
onready var camera_pivot = $CameraPivot

export(float, 0.5, 1) var mouse_sensetivity: float = 0.3
export(float, -90, 0) var min_pitch: float = -90
export(float, 0, 90) var max_pitch: float = 90


func do_on_embark():
	camera.current = true


func do_on_disembark():
	camera.current = false


func _input(event):
	if is_activated and event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensetivity
		camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensetivity
		camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)
