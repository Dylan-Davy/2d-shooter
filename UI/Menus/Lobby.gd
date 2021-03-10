extends Control

var player_node
var player_count = 1
var chat_node

func _ready():
	get_tree().connect('network_peer_disconnected', self, 'on_player_disconnected')
	get_tree().connect('network_peer_connected', self, 'on_player_connected')
	chat_node = get_node("HBoxContainer/RightBox/Chat/ScrollContainer")
	
	player_node = get_node("HBoxContainer/RightBox/Players")
	
	add_self()
	
	if not Network.host:
		get_node("HBoxContainer/LeftBox/VBoxContainer/Start").queue_free()
		get_node("HBoxContainer/LeftBox/VBoxContainer/Settings").queue_free()

func add_self():
	var label = Label.new()
	label.set("custom_colors/font_color", Color("FFFF00"))
	
	var player
	
	if Network.host:
		player = Network.players[1]
	else:
		player = Network.players[get_tree().get_network_unique_id()]
	
	label.name = str(get_tree().get_network_unique_id())
	label.text = player.name
	player_node.add_child(label)

func _process(delta):
	for player in Network.player_instances:
		var my_bool = false
		
		for existing_lable in player_node.get_children():
			if existing_lable.name == player.name:
				my_bool = true
		
		if my_bool == false:
			var label = Label.new()
			
			if player_count == 1:
				label.set("custom_colors/font_color", Color("e80606"))
			elif player_count == 2:
				label.set("custom_colors/font_color", Color("0419f8"))
			elif player_count == 3:
				label.set("custom_colors/font_color", Color("0be838"))
				
			label.name = player.name
			label.text = player.player_name
			player_node.add_child(label)
			
			player_count += 1
			player.my_colour = player_count

func on_player_disconnected(id):
	player_count = 1
	
	for wait in range(30):
		yield(get_tree(), "idle_frame")
	
	var left_player
	
	for player in Network.player_instances:
		if player.get_network_master() == id:
			left_player = player.player_name
			
	enter_text("Latta bich", left_player)
	
	for existing_label in player_node.get_children():
		existing_label.queue_free()
	
	add_self()

func on_player_connected(id):
	for wait in range(30):
		yield(get_tree(), "idle_frame")
	
	var joined_player
	
	for player in Network.player_instances:
		if player.get_network_master() == id:
			joined_player = player.player_name
			
	enter_text("I have joined the game!", joined_player)
	
sync func enter_text(new_text, player_name):
	var label = Label.new()
	label.text = player_name + ": " + new_text
	label.autowrap = true
	
	label.set("custom_colors/font_color", Color("FFFF00"))
	
	for player in Network.player_instances:
		if player_name == player.player_name:
			if player.my_colour == 2:
				label.set("custom_colors/font_color", Color("e80606"))
			elif player.my_colour == 3:
				label.set("custom_colors/font_color", Color("0419f8"))
			elif player.my_colour == 4:
				label.set("custom_colors/font_color", Color("0be838"))
				
	chat_node.get_node("ChatLines").add_child(label)
	
	yield(get_tree(), "idle_frame")
	
	chat_node.scroll_vertical = chat_node.get_v_scrollbar().max_value
	
	yield(get_tree(), "idle_frame")
	
	chat_node.scroll_vertical = chat_node.get_v_scrollbar().max_value
	
func _on_Start_pressed():
	Game.ui.play()
	Network.start_game()

func _on_Settings_pressed():
	Game.ui.play()
	pass # Replace with function body.

func _on_Leave_pressed():
	Game.ui.play()
	Network.leave_server()

func _on_ChatInput_text_entered(new_text):
	if not new_text == "":
		rpc("enter_text", new_text, Network.my_name)
		get_node("HBoxContainer/RightBox/Chat/ChatInput").text = ""
