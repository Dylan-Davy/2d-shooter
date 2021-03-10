extends "res://Characters/Enemies/Basic enemies/BasicEnemies.gd"

func _ready():
	piercing_res = 1000
	value = 40.0
	attack_rate = 1
	navigation = get_tree().get_root().find_node("Navigation2D", true, false)
	attack_range = 100

func set_stats(number):
	enemy_number = number
	
	if enemy_number == 5 or enemy_number == 6:
		$CharacterCollision.shape.radius = 30
		health = 100
		damage = 150
		physical_res = 20
		energy_res = 10
		plasma_res = 20
		speed = 0.9 * MAX_SPEED
	else:
		$CharacterCollision.shape.radius = 22
		health = 80
		damage = 120
		physical_res = 10
		energy_res = 30
		plasma_res = 0
		speed = MAX_SPEED

func _on_Despawn_timeout():
	queue_free()
