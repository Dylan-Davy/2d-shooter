extends Node2D

var pistol = {"name": "Pistol", "max_ammo": 15, "ammo": 15, "fire_rate": 0.5, "reload": 1, "damage": 25, "speed": 1750, "walk_speed": 0,\
"radius": 3, "x": -10, "height": 40, "damage_type": "physical", "asset": "Fire_small_asset.png", "sfx": "Pistol.wav", "type": "projectile", "upgrades": 0}

var current_weapon = pistol# pull from save, and have default?
var weapons = [pistol] # pull from inventory on load, needs to update with inventory update
var Bullet = preload("res://Items/Bullet.tscn")
var weapon_owner
var can_fire1 = true
var can_fire2 = true
var can_fire3 = true
var reloading1 = false
var reloading2 = false
var reloading3 = false
var laser_on = false
var weapon_index = 1
onready var audio = $AudioStreamPlayer2D

puppet var current_weapon_slave = pistol

signal burst_timeout

func _ready():
	weapon_owner = get_parent()
	weapon_changed()
	$Wep1.wait_time = weapons[0].fire_rate

func _process(delta):
	if is_network_master():
		change_weapon()
	else:
		weapon_changed()

func _physics_process(delta):
	if is_network_master():
		firing(delta)

func change_weapon():
	if Input.is_action_just_pressed("weapon_1") and not Input.is_action_pressed("shoot"):
		if current_weapon.type == "laser":
			rpc("disable_laser")
		current_weapon = weapons[0]
		rset("current_weapon_slave", current_weapon)
		yield(get_tree(), "idle_frame")
		rpc("weapon_changed")
		weapon_index = 1
	elif Input.is_action_just_pressed("weapon_2") and not Input.is_action_pressed("shoot"):
		if weapons.size() > 1:
			if current_weapon.type == "laser":
				rpc("disable_laser")
			current_weapon = weapons[1]
			rset("current_weapon_slave", current_weapon)
			yield(get_tree(), "idle_frame")
			rpc("weapon_changed")
			weapon_index = 2
	elif Input.is_action_just_pressed("weapon_3") and not Input.is_action_pressed("shoot"):
		if weapons.size() > 2:
			if current_weapon.type == "laser":
				rpc("disable_laser")
			current_weapon = weapons[2]
			rset("current_weapon_slave", current_weapon)
			yield(get_tree(), "idle_frame")
			rpc("weapon_changed")
			weapon_index = 3
	elif Input.is_action_just_pressed("reload") and not Input.is_action_pressed("shoot") and not current_weapon.ammo == current_weapon.max_ammo:
		if current_weapon.type == "Laser":
			rpc("disable_laser")
			
		if weapon_index == 1:
			if not reloading1:
				current_weapon.ammo = 0
				$Wep1.wait_time = 0.001
				$Wep1.start()
		elif weapon_index == 2:
			if not reloading2:
				current_weapon.ammo = 0
				$Wep2.wait_time = 0.001
				$Wep2.start()
		elif weapon_index == 3:
			if not reloading3:
				current_weapon.ammo = 0
				$Wep3.wait_time = 0.001
				$Wep3.start()

func update_weapons():
	$Wep1.wait_time = weapons[0].fire_rate
	if weapons.size() > 1:
		$Wep2.wait_time = weapons[1].fire_rate
	if weapons.size() > 2:
		$Wep3.wait_time = weapons[2].fire_rate
		
sync func weapon_changed():
	if not is_network_master():
		current_weapon = current_weapon_slave
	
	audio.stream = load("res://Assets/SFX/Gunshots/" + current_weapon.sfx)
	weapon_owner.speed = weapon_owner.MAX_SPEED - current_weapon.walk_speed

func on_weapons_updated():
	pass # update weapons array from inventory
	
func firing(delta):
	var rotation = deg2rad(get_parent().rotation_degrees + self.rotation_degrees)
	
	if Input.is_action_pressed("shoot") and weapon_owner.parent_can_fire:
		if can_fire1 and weapon_index ==  1:
			rpc_unreliable('shoot',rotation)
			can_fire1 = false
			$Wep1.start()
		elif can_fire2 and weapon_index == 2:
			rpc_unreliable('shoot',rotation)
			can_fire2 = false
			$Wep2.start()
		elif can_fire3 and weapon_index == 3:
			rpc_unreliable('shoot',rotation)
			can_fire3 = false
			$Wep3.start()
	elif Input.is_action_just_released("shoot") and laser_on:
		rpc("disable_laser")

sync func shoot(rotation):
	if current_weapon.type == "spread":
		audio.volume_db = Game.music.volume_db - 20
		audio.play()
		current_weapon.ammo -= 1
		
		for shot in range(current_weapon.shots):
			var b = Bullet.instance()
			var spread = current_weapon.spread * (randf() - 0.5)
			add_child(b)
			b.start(self.global_position, rotation + spread, current_weapon, weapon_owner)
	elif current_weapon.type == "charge_up":
		current_weapon.ammo -= 1
	elif current_weapon.type == "laser":
		if not laser_on:
			$LaserBeam2D.set_is_casting(true, current_weapon)
			laser_on = true
			audio.volume_db = Game.music.volume_db - 20
			audio.play()
			
	elif current_weapon.type == "burst":
		
		$BurstTimer.wait_time = current_weapon.spread
			
		for shot in range(current_weapon.shots):
			var b = Bullet.instance()
			add_child(b)
			b.start(self.global_position, rotation, current_weapon, weapon_owner)
			$BurstTimer.start()
			current_weapon.ammo -= 1
			audio.volume_db = Game.music.volume_db - 20
			audio.play()
			yield(self, "burst_timeout")
			rotation = deg2rad(get_parent().rotation_degrees + self.rotation_degrees)
	else:
		var b = Bullet.instance()
		add_child(b)
		b.start(self.global_position, rotation, current_weapon, weapon_owner)
		current_weapon.ammo -= 1
		audio.volume_db = Game.music.volume_db - 20
		audio.play()

sync func disable_laser():
	$LaserBeam2D.set_is_casting(false, current_weapon)
	laser_on = false
	audio.stop()

func _on_Wep1_timeout():
	if weapons[0].ammo <= 0 and not reloading1:
		$Wep1.wait_time = weapons[0].reload
		can_fire1 = false
		reloading1 = true
		$Wep1.start()
	elif not reloading1:
		can_fire1 = true
	else:
		$Wep1.wait_time = weapons[0].fire_rate
		weapons[0].ammo = weapons[0].max_ammo
		reloading1 = false
		can_fire1 = true

func _on_Wep2_timeout():
	if weapons[1].ammo <= 0 and not reloading2:
		$Wep2.wait_time = weapons[1].reload
		can_fire2 = false
		reloading2 = true
		$Wep2.start()
	elif not reloading2:
		can_fire2 = true
	else:
		$Wep2.wait_time = weapons[1].fire_rate
		weapons[1].ammo = weapons[1].max_ammo
		reloading2 = false
		can_fire2 = true

func _on_Wep3_timeout():
	if weapons[2].ammo <= 0 and not reloading3:
		$Wep3.wait_time = weapons[2].reload
		can_fire3 = false
		reloading3 = true
		$Wep3.start()
	elif not reloading3:
		can_fire3 = true
	else:
		$Wep3.wait_time = weapons[2].fire_rate
		weapons[2].ammo = weapons[2].max_ammo
		reloading3 = false
		can_fire3 = true

func _on_BurstTimer_timeout():
	emit_signal("burst_timeout")
