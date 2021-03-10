extends "res://Characters/Enemies/Basic enemies/BasicEnemies.gd"

func _ready():
	health = 1000
	physical_res = 40
	energy_res = 10
	plasma_res = 70
	piercing_res = 3000
	value = 100.0
	speed = MAX_SPEED - 100
	damage = 300
	attack_rate = 3
	navigation = get_tree().get_root().find_node("Navigation2D", true, false)
	attack_range = 200
	$CharacterCollision.shape.radius = 30

func _on_Despawn_timeout():
	queue_free()
