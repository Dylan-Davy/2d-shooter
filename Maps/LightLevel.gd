extends CanvasModulate

func _ready():
	color = Color("333333")
	visible = true

func _on_PowerSwitch_power_on():
	rpc("power_on")
	
sync func power_on():
	color = Color("999999")
	get_parent().get_node("TemplateSpawner").monsters = true
	
	for player in get_tree().get_nodes_in_group("Players"):
		player.get_node("Weapons").get_node("Torch").energy = 0.4
	
	for machine in get_tree().get_nodes_in_group("Machines"):
		machine.power = true
