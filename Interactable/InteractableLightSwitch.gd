extends Interactable


export var light: NodePath
export var on_by_default = true
export var energy_when_on = 1
export var energy_when_off = 0

onready var light_node = get_node(light)
onready var is_on = on_by_default

func set_light_energy():
	if is_on:
		light_node.set_param(Light.PARAM_ENERGY, energy_when_on)
	else:
		light_node.set_param(Light.PARAM_ENERGY, energy_when_off)
	
	
func _ready():
	set_light_energy()
	
	
func interact():
	is_on = !is_on
	set_light_energy()
	

func get_interaction_text():
	if is_on:
		return 'switch off'
	else:
		return 'switch on'
