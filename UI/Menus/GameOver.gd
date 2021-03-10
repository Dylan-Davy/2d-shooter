extends Control

var in_server = true

func _ready():
	var player_node = get_node("VBoxContainer/Players")
	get_node("VBoxContainer/Round").text = "You survived to round " + str(Game.game_round)
	
	for player in Game.players:
		var label = Label.new()
		
		if player.colour == 1:
			label.set("custom_colors/font_color", Color("FFFF00"))
		elif player.colour == 2:
			label.set("custom_colors/font_color", Color("e80606"))
		elif player.colour == 3:
			label.set("custom_colors/font_color", Color("0419f8"))
		elif player.colour == 4:
			label.set("custom_colors/font_color", Color("0be838"))
			
		label.text = player.name + ": " + str(player.points)
		player_node.add_child(label)

func _process(delta):
	if in_server:
		if not get_tree().is_network_server():
			if Network.peer == null:
				get_node("VBoxContainer/PlayAgain").disabled = false
				in_server = false
			else:
				get_node("VBoxContainer/PlayAgain").disabled = true
	
func _on_PlayAgain_pressed():
	if not Network.peer == null:
		Network.leave_server()
	
	if Network.host == true:
		Network.create_server(Network.my_name)
	else:
		Network.connect_to_server(Network.my_name, Network.host_ip)
		
	Game.ui.play()

func _on_Leave_pressed():
	Game.ui.play()
	get_tree().change_scene("res://UI/Menus/MainMenu.tscn")
