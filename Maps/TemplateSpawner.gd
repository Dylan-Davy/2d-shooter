extends Node2D

var game_round = 1
var round_scaler = 1
var players
var picker
var enemy_count
var possible_spawns
var enemies_node
var zombie_count = 1
var monsters = false
var enemy_1 = preload("res://Characters/Enemies/Basic enemies/Zombie.tscn")
var enemy_2 = preload("res://Characters/Enemies/Basic enemies/Monster.tscn")

func _ready():
	randomize()
	enemies_node = get_tree().get_root().find_node("Enemies", true, false)
	possible_spawns = $SpawnPoints.get_children()
	players = get_tree().get_nodes_in_group("Players")
	$SpawnTimer.wait_time = 3
	enemy_count = 10 + players.size() * 2
	$SpawnTimer.start()
	round_scaler = 2 * Network.players.size()

func _process(delta):
	if enemy_count <= 0 and get_tree().get_nodes_in_group("Enemies").size() == 0 and Network.host:
		rpc("round_up")
		$SpawnTimer.stop()
		$RoundTimer.wait_time = clamp(round_scaler, 3, 15)
		$RoundTimer.start()
			
func spawn():
	if Network.host:
		var spawn = possible_spawns[randi() % possible_spawns.size() -1]
		var pos = spawn.position
		
		if get_tree().get_nodes_in_group("Enemies").size() < 5 + round_scaler * players.size() and enemy_count > 0:
			if picker == 1 or picker == 2:
				var enemy_number = (randi() % 6) + 1
				rpc("add_enemy", enemy_number, pos, zombie_count)
				enemy_count -= 1;
			elif picker == 3:
				var enemy_number = (randi() % 2) + 1
				rpc("add_enemy2", enemy_number, pos, zombie_count)
				enemy_count -= 2;
			
			zombie_count += 1;
			
			$SpawnTimer.wait_time = 3.5 - players.size() / 10 - round_scaler / 8 + randf() * (5.2 - round_scaler / 5)
			$SpawnTimer.start()

sync func round_up():
	players = get_tree().get_nodes_in_group("Players")
	
	game_round += 1
	
	for player in players:
		player.respawn()
	
	if round_scaler <= 24:
		round_scaler += players.size()
		round_scaler = clamp(round_scaler, 0, 24)
		
	enemy_count = 10 + 2 * game_round + players.size() * game_round 

sync func add_enemy(enemy_number, pos, count):
	var e = enemy_1.instance()
	e.name = str(count)
	e.set_stats(enemy_number)
	enemies_node.add_child(e)
	e.start(game_round, round_scaler, pos)

sync func add_enemy2(enemy_number, pos, count):
	var e = enemy_2.instance()
	e.name = str(count)
	e.set_stats(enemy_number)
	enemies_node.add_child(e)
	e.start(game_round, round_scaler, pos)

func _on_SpawnTimer_timeout():
	if not monsters:
		picker = 1
	else:
		picker = randi() % 3 + 1
		
	spawn()

func _on_RoundTimer_timeout():
	spawn()
