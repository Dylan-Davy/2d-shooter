extends CanvasLayer

onready var left_box = $Control/HBoxContainer/VBoxContainer
onready var right_box = $Control/HBoxContainer/VBoxContainer2
var weapons

func _ready():
	left_box.get_node("PlayerInfo/Health").max_value = get_parent().max_health
	left_box.get_node("PlayerInfo/Health").rect_min_size.x = get_parent().max_health / 2
	left_box.get_node("PlayerInfo/Stamina").rect_min_size.x = get_parent().max_stamina * 2.5
	weapons = get_parent().get_node("Weapons")
	get_tree().connect('network_peer_disconnected', self, 'on_player_disconnected')
	
func _process(delta):
	update_HUD()
		
func update_HUD():
	right_box.get_node("Round").text = "Round: " + str(get_parent().get_parent().get_node("TemplateSpawner").game_round)
	left_box.get_node("PlayerInfo/Health").value = get_parent().health
	left_box.get_node("PlayerInfo/Stamina").value = get_parent().stamina
	left_box.get_node("PlayerInfo/Points").text = ("Points: " + str(stepify(get_parent().points,1)))
	left_box.get_node("PlayerInfo/Position").text = ("Coords: " + str(stepify(get_parent().position.x,1)) + " " + str(stepify(get_parent().position.y,1)))
	
	right_box.get_node("CurrentWeapon").text = ("Current Weapon: " + weapons.current_weapon.name + " " + str(weapons.current_weapon.ammo) + "/" + str(weapons.current_weapon.max_ammo))
	right_box.get_node("HBoxContainer/Wep1").text = ("1: " + weapons.weapons[0].name)
	
	if  get_parent().get_node("Weapons").weapons.size() > 1:
		right_box.get_node("HBoxContainer/Wep2").text = ("2: " + weapons.weapons[1].name)
	else:
		right_box.get_node("HBoxContainer/Wep2").text = "Weapon 2:"
	
	if get_parent().get_node("Weapons").weapons.size() > 2:
		right_box.get_node("HBoxContainer/Wep3").text = ("3: " + weapons.weapons[2].name)
	else:
		right_box.get_node("HBoxContainer/Wep3").text = "Weapon 3:"
		
	for player in get_tree().get_nodes_in_group("Players"):
		var my_bool = false
		
		for existing_lable in left_box.get_node("Players").get_children():
			if existing_lable.name == player.name:
				existing_lable.text = player.player_name + " " + str(stepify(player.slave_points, 1))
				my_bool = true
		
		if my_bool == false and not get_parent().name == player.name:
			var label = Label.new()
			
			if player.my_colour == 2:
				label.set("custom_colors/font_color", Color("e80606"))
			elif player.my_colour == 3:
				label.set("custom_colors/font_color", Color("0419f8"))
			elif player.my_colour == 4:
				label.set("custom_colors/font_color", Color("0be838"))
				
			label.name = player.name
			label.text = player.player_name + " " + str(stepify(player.slave_points, 1))
			left_box.get_node("Players").add_child(label)
	
func on_player_disconnected(id):
	for existing_lable in left_box.get_node("Players").get_children():
		if existing_lable.name == str(id):
			existing_lable.queue_free()
