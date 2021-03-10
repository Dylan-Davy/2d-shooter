extends Node

var host_ip = '121.75.114.138'
const DEFAULT_PORT = 7474
const MAX_PLAYERS = 4
var players = { }
var player_instances = []
var self_data = {name = '', position = Vector2(360, 180), q_ability = "", r_ability = ""}
var peer
var map
var host
var my_name
var solo

func _ready():
	get_tree().connect('network_peer_disconnected', self, 'on_player_disconnected')
	get_tree().connect('network_peer_connected', self, 'on_player_connected')
	get_tree().connect('connected_to_server', self, 'connected_to_server')
	get_tree().connect('server_disconnected', self, 'leave_server')
	
func create_server(player_nickname):
	host = true
	self_data.name = player_nickname
	my_name = player_nickname
	players[1] = self_data
	peer = NetworkedMultiplayerENet.new()
	
	if peer.create_server(DEFAULT_PORT, MAX_PLAYERS - 1) == OK:
		get_tree().set_network_peer(peer)
		
		if solo:
			get_tree().change_scene("res://UI/Menus/Lobby.tscn")
			map = load("res://Maps/TestLevel.tscn")
		else:
			var upnp = UPNP.new()
			upnp.discover()
		
			if upnp.add_port_mapping(DEFAULT_PORT) == 0:
				get_tree().change_scene("res://UI/Menus/Lobby.tscn")
				map = load("res://Maps/TestLevel.tscn")
			else:
				peer.close_connection()
				print("UPNP failed. This router does not have UPNP activated.")

func connect_to_server(player_nickname, requested_ip):
	host = false
	my_name = player_nickname
	
	if not requested_ip == "":
		host_ip = requested_ip
	
	self_data.name = player_nickname
	peer = NetworkedMultiplayerENet.new()
	peer.create_client(host_ip, DEFAULT_PORT)
	get_tree().set_network_peer(peer)
	
func connected_to_server():
	get_tree().change_scene("res://UI/Menus/Lobby.tscn")
	map = load("res://Maps/TestLevel.tscn")
	var local_player_id = get_tree().get_network_unique_id()
	players[local_player_id] = self_data
	rpc_id(1, 'send_player_info', local_player_id, self_data)

func start_game():
	rpc("all_start")
	
sync func all_start():
	get_tree().change_scene_to(map)
	peer.set_refuse_new_connections(true)

func on_player_disconnected(id):
	players.erase(id)
	
	var player_leaving
	
	if get_tree().get_current_scene().name == "Lobby":
		for player in player_instances:
			if player.name == str(id):
				player_leaving = player
		
		player_instances.erase(player_leaving)
	
func on_player_connected(connected_player_id):
	for wait in range(10):
		yield(get_tree(), "idle_frame")

	var local_player_id = get_tree().get_network_unique_id()
	
	if not host:
		rpc_id(1, 'request_player_info', local_player_id, connected_player_id)

remote func request_player_info(request_from_id, player_id):
	rpc_id(request_from_id, 'send_player_info', player_id, players[player_id])

remote func send_player_info(id, info):
	players[id] = info
	var new_player = load('res://Characters/Player/Player.tscn').instance()
	new_player.name = str(id)
	new_player.set_network_master(id)
	new_player.player_name = players[id].name
	player_instances.append(new_player)
	
func leave_server():
	if not get_tree().get_current_scene().name == "GameOver":
		get_tree().change_scene("res://UI/Menus/MainMenu.tscn")
	
	Game.music.play()
	peer.close_connection()
	peer = null
	players = { }
	player_instances = []
	self_data = {name = '', position = Vector2(360, 180), q_ability = "", r_ability = ""}
	map = null
