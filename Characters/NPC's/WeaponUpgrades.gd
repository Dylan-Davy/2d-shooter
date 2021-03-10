extends StaticBody2D
var can_activate = false
var entered_player
var power = false

export var price = 5000
export var upgrades = 0

func _process(delta):
	if can_activate and Input.is_action_just_pressed("interact") and power and entered_player.points >= \
	price and entered_player.get_node("Weapons").current_weapon.upgrades == upgrades:
		var weapon = entered_player.get_node("Weapons").current_weapon
		entered_player.points -= price
		weapon.upgrades += 1
		weapon.damage *= 1.25
		weapon.damage = int(weapon.damage)
		weapon.max_ammo *= 1.25
		weapon.max_ammo = int(weapon.max_ammo)
		weapon.ammo = weapon.max_ammo
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Players") and body.is_network_master():
		entered_player = body
		can_activate = true
		$Price/CenterContainer/Popup/Label.text = "Weapon upgrade: " + str(price) + " points."
		$Price/CenterContainer/Popup.popup_centered()

func _on_Area2D_body_exited(body):
	if body == entered_player:
		can_activate = false
		entered_player = null
		$Price/CenterContainer/Popup.hide()
