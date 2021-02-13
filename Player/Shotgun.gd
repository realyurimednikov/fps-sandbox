#extends "res://Player/Weapon.gd"
extends Weapon

#onready var raycast = $"../Head/Camera/RayCast"


export var fire_range = 10

func _ready():
	raycast.cast_to = Vector3(0, 0, -fire_range)
