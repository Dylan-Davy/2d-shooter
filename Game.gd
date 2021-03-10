extends Node

var self_data = {name = '', points = 0, colour = 0}
var game_round = 0
var players = []
onready var music = $BackgroundMusic
onready var ui = $UI

func _ready():
	music.stream = load("res://Assets/SFX/Ambient/Stalking-Prey.ogg")
	music.play()
	
func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		if OS.window_fullscreen == true:
			OS.window_fullscreen = false
		else:
			OS.window_fullscreen = true

func add_Player(player_name, player_points, player_colour):
	self_data = {name = '', points = 0, colour = 0}
	self_data.name = player_name
	self_data.points = player_points
	self_data.colour = player_colour
	players.append(self_data)

func check_Game_Over():
	var game_players = get_tree().get_nodes_in_group("Players")
	var lose = true
	
	for player in game_players:
		if player.down == false:
			lose = false
		
	if lose == true:
		players = []
		game_round = get_tree().get_current_scene().get_node("TemplateSpawner").game_round
		
		for player in game_players:
			add_Player(player.player_name, player.lifetime_points, player.my_colour)
			
		get_tree().change_scene("res://UI/Menus/GameOver.tscn")
