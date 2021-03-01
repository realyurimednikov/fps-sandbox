extends Control


onready var ammo_label = $HBoxContainer/AmmoLabel
onready var interact_label = $InteractLabel
onready var health_bar = $HBoxContainer2/HealthBar
onready var ammo_type_label = $HBoxContainer/WeaponTypeLabel


func update_ammo(current, total):
	ammo_label.text = str(current) + "/" + str(total)


func show_interaction_text(text):
	interact_label.text=  text
	interact_label.visible = true


func hide_interaction_text():
	interact_label.visible = false


func update_health(value):
	health_bar.value = value


func update_ammo_type(type):
	ammo_type_label.text = type
