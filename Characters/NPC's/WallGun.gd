extends Area2D

var smg = {"name": "SMG", "max_ammo": 50, "ammo": 50, "fire_rate": 0.12, "reload": 1.2, "damage": 25, "speed": 1500, "walk_speed": 10,\
"radius": 3, "x": -10, "height": 40, "damage_type": "physical", "asset": "Fire_small_asset.png", "sfx": "Pistol.wav", "price": 750, "type": "projectile", "upgrades": 0}

var rifle = {"name": "Rifle", "max_ammo": 30, "ammo": 30, "fire_rate": 0.22, "reload": 1.5, "damage": 80, "speed": 2500, "walk_speed": 30,\
"radius": 5, "x": -5, "height": 60, "damage_type": "physical", "asset": "Fire_big_asset.png", "sfx": "Rifle.wav", "price": 1800, "type": "projectile", "upgrades": 0}

var revolver = {"name": "Revolver", "max_ammo": 6, "ammo": 6, "fire_rate": 0.15, "reload": 5, "damage": 180, "speed": 2000, "walk_speed": 0,\
"radius": 5, "x": -5, "height": 60, "damage_type": "physical", "asset": "Fire_big_asset.png", "sfx": "Rifle.wav", "price": 1250, "type": "projectile", "upgrades": 0}

var hunting_rifle = {"name": "HuntingRifle", "max_ammo": 7, "ammo": 7, "fire_rate": 2, "reload": 3, "damage": 250, "speed": 3000, "walk_speed": 40,\
"radius": 5, "x": -5, "height": 60, "damage_type": "physical", "asset": "Fire_big_asset.png", "sfx": "Rifle.wav", "price": 500, "type": "projectile", "upgrades": 0}

var sniper_rifle = {"name": "SniperRifle", "max_ammo": 5, "ammo": 5, "fire_rate": 2.3, "reload": 3.5, "damage": 500, "speed": 3900, "walk_speed": 60,\
"radius": 6, "x": -5, "height": 60, "damage_type": "physical", "asset": "Fire_big_asset.png", "sfx": "Rifle.wav", "price": 2200, "type": "piercing", "upgrades": 0}

var plasma_rifle = {"name": "PlasmaRifle", "max_ammo": 100, "ammo": 100, "fire_rate": 0.18, "reload": 3, "damage": 70, "speed": 1000, "walk_speed": 30,\
"radius": 6, "x": -20, "height": 60, "damage_type": "plasma", "asset": "plasma.png", "sfx": "plasma.ogg", "price": 2000, "type": "projectile", "upgrades": 0}

var rail_gun = {"name": "RailGun", "max_ammo": 1, "ammo": 1, "fire_rate": 1, "reload": 5, "damage": 1000, "speed": 4100, "walk_speed": 60,\
"radius": 6, "x": -10, "height": 60, "damage_type": "energy", "asset": "Energy.png", "sfx": "Energy.wav", "price": 2600, "type": "piercing", "upgrades": 0}

var energy_rifle = {"name": "EnergyRifle", "max_ammo": 50, "ammo": 50, "fire_rate": 0.2, "reload": 2, "damage": 50, "speed": 2500, "walk_speed": 30,\
"radius": 6, "x": -10, "height": 60, "damage_type": "energy", "asset": "Energy.png", "sfx": "Energy.wav", "price": 2000, "type": "piercing", "upgrades": 0}

var double_barrel = {"name": "DoubleBarrel", "max_ammo": 2, "ammo": 2, "fire_rate": 0.4, "reload": 2.8, "damage": 40, "speed": 2000, "walk_speed": 30,\
"radius": 2, "x": -3, "height": 30, "damage_type": "physical", "asset": "Fire_small_asset.png", "sfx": "Rifle.wav", "price": 750, "type": "spread", "shots": 7, "spread": 0.3, "upgrades": 0}

var pump_action = {"name": "PumpAction", "max_ammo": 7, "ammo": 7, "fire_rate": 0.8, "reload": 4, "damage": 50, "speed": 1800, "walk_speed": 30,\
"radius": 2, "x": -3, "height": 30, "damage_type": "physical", "asset": "Fire_small_asset.png", "sfx": "Rifle.wav", "price": 1500, "type": "spread", "shots": 9, "spread": 0.5, "upgrades": 0}

var plasma_shotgun = {"name": "PlasmaShotgun", "max_ammo": 20, "ammo": 20, "fire_rate": 0.6, "reload": 3, "damage": 25, "speed": 1000, "walk_speed": 40,\
"radius": 2, "x": -3, "height": 30, "damage_type": "plasma", "asset": "plasma.png", "sfx": "plasma.ogg", "price": 2200, "type": "spread", "shots": 15, "spread": 0.6, "upgrades": 0}

var burst_smg = {"name": "BurstSMG", "max_ammo": 54, "ammo": 54, "fire_rate": 0.4, "reload": 1.5, "damage": 30, "speed": 1500, "walk_speed": 10,\
"radius": 3, "x": -10, "height": 40, "damage_type": "physical", "asset": "Fire_small_asset.png", "sfx": "Pistol.wav", "price": 950, "type": "burst", "shots": 3, "spread": 0.1, "upgrades": 0}

var burst_rifle = {"name": "BurstRifle", "max_ammo": 36, "ammo": 36, "fire_rate": 1, "reload": 2.2, "damage": 90, "speed": 2500, "walk_speed": 30,\
"radius": 5, "x": -5, "height": 60, "damage_type": "physical", "asset": "Fire_big_asset.png", "sfx": "Rifle.wav", "price": 1600, "type": "burst", "shots": 3, "spread": 0.12, "upgrades": 0}

var energy_burst = {"name": "EnergyBurst", "max_ammo": 45, "ammo": 45, "fire_rate": 0.8, "reload": 2.4, "damage": 80, "speed": 2500, "walk_speed": 30,\
"radius": 6, "x": -10, "height": 60, "damage_type": "energy", "asset": "Energy.png", "sfx": "Energy.wav", "price": 1600, "type": "burst", "shots": 3, "spread": 0.12, "upgrades": 0}

var laser = {"name": "Laser", "max_ammo": 1, "ammo": 1, "fire_rate": 0.01, "reload": 0.01, "damage": 500, "speed": 1, "walk_speed": 60,\
"damage_type": "energy", "asset": "Energy.png", "sfx": "laser.wav", "price": 5000, "type": "laser", "upgrades": 0}

var can_buy = false
var swap = false
var player
var weapon
var weapon_dict
var price

func _ready():
	load_data()
	
func load_data():
	$Label.text = self.name
	weapon = self.name
	if weapon == "SMG":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0014_gun.png")
		weapon_dict = smg.duplicate()
		price = weapon_dict.price
	elif weapon == "Rifle":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0000_gun.png")
		weapon_dict = rifle.duplicate()
		price = weapon_dict.price
	elif weapon == "Revolver":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0014_gun.png")
		weapon_dict = revolver.duplicate()
		price = weapon_dict.price
	elif weapon == "HuntingRifle":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0000_gun.png")
		weapon_dict = hunting_rifle.duplicate()
		price = weapon_dict.price
	elif weapon == "SniperRifle":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0000_gun.png")
		weapon_dict = sniper_rifle.duplicate()
		price = weapon_dict.price
	elif weapon == "PlasmaRifle":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0001_fire.png")
		weapon_dict = plasma_rifle.duplicate()
		price = weapon_dict.price
	elif weapon == "RailGun":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0001_fire.png")
		weapon_dict = rail_gun.duplicate()
		price = weapon_dict.price
	elif weapon == "EnergyRifle":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0001_fire.png")
		weapon_dict = energy_rifle.duplicate()
		price = weapon_dict.price
	elif weapon == "DoubleBarrel":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0000_gun.png")
		weapon_dict = double_barrel.duplicate()
		price = weapon_dict.price
	elif weapon == "PumpAction":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0000_gun.png")
		weapon_dict = pump_action.duplicate()
		price = weapon_dict.price
	elif weapon == "PlasmaShotgun":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0001_fire.png")
		weapon_dict = plasma_shotgun.duplicate()
		price = weapon_dict.price
	elif weapon == "BurstSMG":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0014_gun.png")
		weapon_dict = burst_smg.duplicate()
		price = weapon_dict.price
	elif weapon == "BurstRifle":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0000_gun.png")
		weapon_dict = burst_rifle.duplicate()
		price = weapon_dict.price
	elif weapon == "EnergyBurst":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0001_fire.png")
		weapon_dict = energy_burst.duplicate()
		price = weapon_dict.price
	elif weapon == "Laser":
		$Sprite.texture = load("res://Assets/GFX/Items/Weapons/Icons/items_0001_fire.png")
		weapon_dict = laser.duplicate()
		price = weapon_dict.price
	
func _process(delta):
	if can_buy and Input.is_action_just_pressed("interact") and not player.get_node("Weapons").weapons.has(weapon_dict):
		if swap == true:
			var index = player.get_node("Weapons").weapons.find(player.get_node("Weapons").current_weapon)
			player.get_node("Weapons").weapons[index] = weapon_dict
			player.get_node("Weapons").current_weapon = weapon_dict
			player.get_node("Weapons").rset("current_weapon_slave", player.get_node("Weapons").current_weapon)
			
			yield(get_tree(), "idle_frame")
			
			player.get_node("Weapons").rpc("weapon_changed")
			swap = false
		else:
			player.get_node("Weapons").weapons.append(weapon_dict)

		player.points -= price
		player.get_node("Weapons").update_weapons()

func _on_WallGun_body_entered(body):
	if body.is_in_group("Players") and body.is_network_master():
		load_data()
		can_buy = true
		player = body
		
		if player.points < price:
			can_buy = false
		elif player.get_node("Weapons").weapons.size() == 3:
			swap = true
			
		if not weapon_dict in player.get_node("Weapons").weapons:
			$Price/CenterContainer/Popup/Label.text = weapon_dict.name + ": " + str(price) + " points."
			$Price/CenterContainer/Popup.popup_centered()

func _on_WallGun_body_exited(body):
	if body.is_in_group("Players") and body.is_network_master():
		can_buy = false
		player = null
		
		$Price/CenterContainer/Popup.hide()
