extends KinematicBody2D

var speed
var damage
var velocity
var damage_type
var enemy
var weapon_owner
var current_weapon
var piercing_counter

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	move_and_collide(velocity * delta)
	
func start(pos, dir, current_weapon, wep_owner):
	weapon_owner = wep_owner
	self.current_weapon = current_weapon
	
	speed = current_weapon.speed
	damage = current_weapon.damage
	piercing_counter = current_weapon.speed
	$Area2D/CollisionShape2D.shape.radius = current_weapon.radius
	$Area2D/CollisionShape2D.shape.height = current_weapon.height
	$Area2D/CollisionShape2D.position.x = current_weapon.x
	damage_type = current_weapon.damage_type
	$Sprite.texture = load("res://Assets/GFX/Items/Bullets/" + current_weapon.asset)
	
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Enemies"):
		if current_weapon.type == "projectile" or current_weapon.type == "spread" or current_weapon.type == "burst":
			if weapon_owner.is_network_master():
				enemy = body
				enemy.hurt(weapon_owner, damage, damage_type)
			
			queue_free()
		elif current_weapon.type == "piercing":
			if weapon_owner.is_network_master():
				enemy = body
				enemy.hurt(weapon_owner, damage, damage_type)
				
			piercing_counter -= enemy.piercing_res
			
			if piercing_counter <= 0:
				queue_free()
				
	else:
		queue_free()
