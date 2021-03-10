extends "res://Characters/Enemies/Basic enemies/BasicEnemies.gd"

func _ready():
	physical_res = 20
	energy_res = 0
	plasma_res = 40
	piercing_res = 1500
	value = 60.0
	damage = 150
	attack_rate = 1
	navigation = get_tree().get_root().find_node("Navigation2D", true, false)
	attack_range = 120
	$CharacterCollision.shape.radius = 30

func set_stats(number):
	enemy_number = number
	
	if enemy_number == 1:
		health = 150
		speed = MAX_SPEED - 50
	else:
		health = 70
		speed = MAX_SPEED + 30

func _on_Despawn_timeout():
	queue_free()
