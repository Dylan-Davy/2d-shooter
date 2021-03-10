extends Control

var player_name = ""
var host_ip = ""

func _on_Name_text_changed(new_text):
	player_name = new_text

func _on_IP_text_changed(new_text):
	host_ip = new_text
	
func _on_CreateButton_pressed():
	if player_name == "":
		return
	Game.ui.play()
	Network.solo = false
	Network.create_server(player_name)

func _on_JoinButton_pressed():
	if player_name == "":
		return
	Game.ui.play()
	Network.connect_to_server(player_name, host_ip)

func _on_SinglePlayer_pressed():
	Game.ui.play()
	Network.solo = true
	Network.create_server("Solo")
