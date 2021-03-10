extends "res://Characters/TemplateCharacter.gd"

var torch = ""
var player_name
var stamina = 100
var points = 100000
var lifetime_points = 0
var rolling = false
var speed = MAX_SPEED
var parent_can_fire = true
var direction = Vector2()
var max_health = 1000
var max_stamina = 100
var my_colour = 1
var down = false
var revive_player
var can_revive
var dead = false
var position_timer = 1

puppet var slave_position = Vector2(360,180)
puppet var slave_motion = Vector2()
puppet var slave_direction = Vector2()
puppet var slave_points = 0
puppet var slave_lifetime_points = 0
puppet var slave_health = 1000

func _ready():
	health = max_health # override this with save file 
	physical_res = 10 # resistances get overrided by inventory/character systems
	energy_res = 25
	plasma_res = 10
	
	if is_network_master():
		$Camera2D.current = true
		var HUD = load("res://UI/IngameHUD.tscn").instance()
		add_child(HUD)
		#Mobile controls
		#var controls = load("res://UI/TouchControls.tscn").instance()
		#add_child(controls)
	
func _process(delta):
	torch_toggle()
	
	if can_revive == true and revive_player.dead == false:
		revive_player()
	
	if health <= 0 and down == false and is_network_master():
		$DeathTimer.start()
		rpc("go_down")
	
	if is_network_master():
		rset("slave_points", points)
		rset("slave_lifetime_points", lifetime_points)
		rset("slave_health", health)
	else:
		points = slave_points
		lifetime_points = slave_lifetime_points
	
	if motion == Vector2(0,0) and not down and not rolling:
		if $Weapons.current_weapon.name == "Pistol" or $Weapons.current_weapon.name == "SMG" or $Weapons.current_weapon.name == "Revolver" or $Weapons.current_weapon.name == "BurstSMG":
			$Sprite.animation = "IdlePistol"
		elif $Weapons.current_weapon.name == "EnergyRifle" or $Weapons.current_weapon.name == "PlasmaRifle" or $Weapons.current_weapon.name == "RailGun" or $Weapons.current_weapon.name == "PlasmaShotgun" or $Weapons.current_weapon.name == "EnergyBurst" or $Weapons.current_weapon.name == "Laser":
			$Sprite.animation = "IdleEnergy"
		else:
			$Sprite.animation = "IdleRifle"
	elif not down and not rolling:
		if $Weapons.current_weapon.name == "Pistol" or $Weapons.current_weapon.name == "SMG" or $Weapons.current_weapon.name == "Revolver" or $Weapons.current_weapon.name == "BurstSMG":
			$Sprite.animation = "WalkingPistol"
		elif $Weapons.current_weapon.name == "EnergyRifle" or $Weapons.current_weapon.name == "PlasmaRifle" or $Weapons.current_weapon.name == "RailGun" or $Weapons.current_weapon.name == "PlasmaShotgun" or $Weapons.current_weapon.name == "EnergyBurst" or $Weapons.current_weapon.name == "Laser":
			$Sprite.animation = "WalkingEnergy"
		else:
			$Sprite.animation = "WalkingRifle"

func _physics_process(delta):
	update_movement(delta)
	move_and_slide(motion)
	position_timer += delta

func update_movement(delta):
	if is_network_master() and down == false:
		if Input.is_action_just_pressed("roll") and rolling == false and stamina > 20 and abs(motion.length()) > 0:
			parent_can_fire = false
			
			rpc("perform_roll")
			
			motion = motion * 2
			stamina -= 30
			
			if $Weapons/Torch.enabled == true:
				torch = "was on"
				rpc("torch_off")
				
			$Rolling.start()
		
		if rolling == false:
			if Input.is_action_pressed("move_down") and not Input.is_action_pressed("move_up"):
				motion.y = 1
			elif Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down"):
				motion.y = -1
			else:
				motion.y = 0
			
			if Input.is_action_pressed("move_right") and not Input.is_action_pressed("move_left"):
				motion.x = 1
			elif Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
				motion.x = -1
			else:
				motion.x = 0
			
			# Touch controls:
			#motion = $TouchControls/Control/Movement/TouchScreenButton.get_value() * speed
			#direction = position + 500 * $TouchControls/Control2/Aim/TouchScreenButton.get_value()
			
			#if not $TouchControls/Control2/Aim/TouchScreenButton.get_value2() == Vector2(0,0):
			#	if not $Weapons.laser_on:
			#		Input.action_press("shoot")
			#else:
			#	Input.action_release("shoot")
				
			# PC controls:
			motion = motion.normalized() * speed
			direction = get_global_mouse_position()
			
			look_at(direction)
			
			if (direction - self.global_position).length() > 100:
				$Weapons.look_at(direction)
			
			if stamina < 100:
				stamina += delta * 10
				
		rset_unreliable('slave_motion', motion)
		rset_unreliable('slave_direction', direction)
		rset_unreliable('slave_position', position)
		
	elif down == false:
		motion = slave_motion
		if position_timer > 1:
			position = slave_position
		if rolling == false:
			look_at(slave_direction)
			$Weapons/LaserBeam2D.look_at(slave_direction)

func _on_Rolling_timeout():
	rpc("finish_roll")
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	if torch == "was on":
		torch = ""
		rpc("torch_on")

func torch_toggle():
	if rolling == false and is_network_master():
		if Input.is_action_just_pressed("torch") and $Weapons/Torch.enabled == true:
			rpc("torch_off")
		elif Input.is_action_just_pressed("torch") and $Weapons/Torch.enabled == false:
			rpc("torch_on")

sync func perform_roll():
	if $Weapons.current_weapon.type == "laser":
		$Weapons.laser_on = false
		$Weapons/LaserBeam2D.growth_time = 0
		$Weapons/LaserBeam2D.set_is_casting(false, $Weapons.current_weapon)
		$Weapons.audio.stop()
	
	rolling = true
	
	yield(get_tree(), "idle_frame")
	
	set_collision_mask_bit(2, false)
	rotation = motion.angle()
	$Sprite.animation = "Dash"

sync func finish_roll():
	set_collision_mask_bit(2, true)
	$Weapons/LaserBeam2D.growth_time = 0.1
	motion = Vector2(0,0)
	$Weapons/LaserBeam2D.visible = true
	yield(get_tree(), "idle_frame")
	rolling = false
	yield(get_tree(), "idle_frame")
	parent_can_fire = true
	
sync func torch_on():
	$Weapons/Torch.enabled = true
	
sync func torch_off():
	$Weapons/Torch.enabled = false

func start(start_position, is_slave):
	global_position = start_position

func revive_player():
	if is_network_master():
		if Input.is_action_just_pressed("interact"):
			revive_player.call_revive()
			can_revive = false
			$Respawn/CenterContainer/Popup.hide()

func call_revive():
	rpc("revive")

func _on_Revive_body_entered(body):
	if down == false and body.is_in_group("Players") and body.down == true and body.dead == false and is_network_master():
		revive_player = body
		can_revive = true
		$Respawn/CenterContainer/Popup.popup_centered()

func _on_Revive_body_exited(body):
	can_revive = false
	revive_player = null
	$Respawn/CenterContainer/Popup.hide()

sync func go_down():
	down = true
	motion = motion * 0
	parent_can_fire = false
	remove_from_group("HuntablePlayer")
	$Sprite.animation = "Death"
	z_index = 0
	set_collision_mask_bit(2, false)
	
	Game.check_Game_Over()
	
sync func revive():
	health = max_health * 0.5
	slave_health = max_health * 0.5
	z_index = 2
	
	yield(get_tree(), "idle_frame")
	
	down = false
	parent_can_fire = true
	add_to_group("HuntablePlayer")
	set_collision_mask_bit(2, true)
	$DeathTimer.stop()

sync func die():
	visible = false
	dead = true
	$Weapons.weapons = [$Weapons.pistol]
	$Weapons.current_weapon = $Weapons.pistol
	$Weapons.current_weapon_slave = $Weapons.pistol
	$Weapons/Wep1.wait_time = $Weapons.pistol.fire_rate
	$Weapons.weapon_index = 1

func respawn():
	health = max_health
	slave_health = max_health
	
	yield(get_tree(), "idle_frame")
	
	z_index = 2
	dead = false
	down = false
	visible = true
	set_collision_mask_bit(2, true)
	parent_can_fire = true
	add_to_group("HuntablePlayer")
		
func _on_DeathTimer_timeout():
	if down == true:
		rpc("die")
