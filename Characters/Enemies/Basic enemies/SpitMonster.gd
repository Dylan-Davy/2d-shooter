extends "res://Characters/Enemies/Basic enemies/BasicEnemies.gd"

func _ready():
	health = 60
	physical_res = 10
	energy_res = 0
	plasma_res = 20
	piercing_res = 1000
	value = 40.0
	speed = MAX_SPEED
	damage = 100
	attack_rate = 2
	navigation = get_tree().get_root().find_node("Navigation2D", true, false)
	attack_range = 80
	$CharacterCollision.shape.radius = 30

func _on_Despawn_timeout():
	queue_free()
