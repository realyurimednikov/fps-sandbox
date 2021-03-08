extends Control


class_name UI

onready var ammo_label = $AmmoContainer/AmmoLabel
onready var interact_label = $InteractLabel
onready var health_bar = $HealthBarContainer/HealthBar
onready var ammo_type_label = $AmmoContainer/WeaponTypeLabel
onready var crosshair_default = $CrosshairDefault
onready var crosshair_active = $CrosshairActive
onready var crosshair_vehicle = $CrosshairVehicle


func update_ammo(current: float, total: float):
	ammo_label.text = str(current) + "/" + str(total)


func show_interaction_text(text: String):
	interact_label.text=  text
	interact_label.visible = true


func hide_interaction_text():
	interact_label.visible = false


func update_health(value: float):
	health_bar.value = value


func update_ammo_type(type: String):
	ammo_type_label.text = type


func show_crosshair_active(is_active: bool):
	if is_active:
		crosshair_active.visible = true
		crosshair_default.visible = false
	else:
		crosshair_active.visible = false
		crosshair_default.visible = true


func activate_vehicle_ui(is_active: bool):
	if is_active:
		crosshair_active.visible = false
		crosshair_default.visible = false
#		crosshair_vehicle.visible = true
		
		ammo_label.visible = false
		ammo_type_label.visible = false
		
	else:
		crosshair_default.visible = true
#		crosshair_vehicle.visible = false
		
		ammo_label.visible = true
		ammo_type_label.visible = true
