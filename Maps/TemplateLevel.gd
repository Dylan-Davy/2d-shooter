extends Node2D

func _ready():
	get_tree().connect('network_peer_disconnected', self, 'on_player_disconnected')
	
	var new_player = load('res://Characters/Player/Player.tscn').instance()
	var info = {name = Network.my_name, position = Vector2(360, 180)}
	new_player.name = str(get_tree().get_network_unique_id())
	new_player.set_network_master(get_tree().get_network_unique_id())
	new_player.player_name = info.name
	add_child(new_player)
	new_player.start(info.position, false)
	
	Game.music.stop()
	
	for player in Network.player_instances:
		add_child(player)
		player.start(Network.players[int(player.name)].position, true)
	
		var player_name = load('res://Characters/Player/PlayerName.tscn').instance()
		player_name.name = player.name + "name"
		add_child(player_name)
		player_name.start(player)
	
func on_player_disconnected(id):
	get_node(str(id) + "name").queue_free()
	get_node(str(id)).queue_free()
	
	Game.check_Game_Over()
