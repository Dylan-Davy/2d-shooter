extends "res://Characters/TemplateCharacter.gd"

var damage
var damage_timing = 1
var attack_rate
var damage_type = "physical"
var value
var navigation
var hunted_player
var players
var path
var speed
var alive = true
var enemy_number = 1
var attack_range
var pathing_timer = 1.5
var step_size = 1

func start(game_round, round_scaler, pos):
	players = get_tree().get_nodes_in_group("HuntablePlayer")
	$Sprite.animation = "Walk" + str(enemy_number)
	
	if players.size() > 0:
		hunted_player = players[0]
	else:
		queue_free()
	
	health = clamp(0.6 * game_round * health, 0.8 * health, health * 50)
		
	speed -= (80 - 3 * round_scaler)
	position = pos

func _physics_process(delta):
	if alive and get_tree().is_network_server():
		if is_instance_valid(hunted_player):
			hunt_player(delta)
		else:
			players = get_tree().get_nodes_in_group("HuntablePlayer")
			hunted_player = players[0]
			var id = hunted_player.get_network_master()
			rpc("update_hunted_player", delta, id)
	
	if alive and is_instance_valid(hunted_player):
		pathing(delta)

func hunt_player(delta):
	players = get_tree().get_nodes_in_group("HuntablePlayer")
	
	if hunted_player.down == true:
		$Sprite.animation = "Walk" + str(enemy_number)
		
		if players.size() > 0:
			hunted_player = players[0]
		else:
			queue_free()
	
	for player in players:
		if is_instance_valid(player):
			if player.position.distance_to(position) < hunted_player.position.distance_to(position):
				hunted_player = player
	
	var id = hunted_player.get_network_master()
	rpc("update_hunted_player", delta, id)

sync func update_hunted_player(delta, id):
	players = get_tree().get_nodes_in_group("HuntablePlayer")
	
	for player in players:
		if player.get_network_master() == id:
			hunted_player = player

func pathing(delta):
	if ((position.distance_to(hunted_player.position) < 500 and pathing_timer > 0.39) or pathing_timer > 1.49):
		path = navigation.get_simple_path(position, hunted_player.position, false)
		pathing_timer = 0
	
	pathing_timer += delta
	
	if (position.distance_to(hunted_player.position) > 300):
		step_size = 2
	else:
		step_size = 1
		
	if position.distance_to(path[step_size]) < 10:
		path = navigation.get_simple_path(position, hunted_player.position, false)
		pathing_timer = 0
	
	look_at(path[step_size])
	motion = (path[step_size] - position).normalized() * speed * 0.85
	
	if (position.distance_to(hunted_player.position) > 50):
		var _velocity = move_and_slide(motion)
		
	if position.distance_to(hunted_player.position) < attack_range and alive and not hunted_player.down:
		deal_damage(delta)
	elif alive:
		yield(get_node("Sprite"), "animation_finished")
		if alive:
			$Sprite.animation = "Walk" + str(enemy_number)
	
func hurt(weapon_owner, damage, damage_type):
	if weapon_owner.is_network_master():
		rpc("take_damage", damage, damage_type)
		
		if health <= 0:
			weapon_owner.points += value
		else:
			if weapon_owner.get_node("Weapons").current_weapon.type == "laser":
				weapon_owner.points += value / 200
				weapon_owner.lifetime_points += value / 200
			else:
				weapon_owner.points += value / 10
				weapon_owner.lifetime_points += value / 10

sync func take_damage(damage, damage_type):
	resistance_type(damage_type)
	damage_taken(damage)
	
	if health <= 0:
		alive = false
		$Sprite.animation = "Death" + str(enemy_number)
		remove_from_group("Enemies")
		$CharacterCollision.queue_free()
		$LightOccluder2D.visible = false
		$Despawn.start()
	
func deal_damage(delta):
	damage_timing += delta * attack_rate
	$Sprite.animation = "Attack" + str(enemy_number)
	
	if damage_timing > 0.99 and hunted_player.rolling == false and hunted_player.down == false:
		damage_timing = 0
		hunted_player.resistance_type(damage_type)
		hunted_player.damage_taken(damage)
