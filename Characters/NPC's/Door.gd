extends StaticBody2D

var can_open = false
var close = true
export var price = 1000
var player

func _process(delta):
	if can_open and Input.is_action_just_pressed("interact") and close \
			and player.points >= price:
		
		player.points -= price
		rpc("open")
		
sync func open():
	$AudioStreamPlayer2D.volume_db = Game.music.volume_db - 10
	$AudioStreamPlayer2D.play()
	$CollisionShape2D.queue_free()
	$LightOccluder2D.queue_free()
	$Price/CenterContainer/Popup.hide()
	self.visible = false
	close = false
	get_parent().get_parent().door_opened(self.name)
	
func _on_PlayerDetection_body_entered(body):
	if body.is_in_group("Players") and body.is_network_master() and close == true:
		can_open = true
		player = body
		$Price/CenterContainer/Popup/Label.text = "Price: " + str(price) + " points."
		$Price/CenterContainer/Popup.popup_centered()

func _on_PlayerDetection_body_exited(body):
	if body == player and body.is_network_master():
		can_open = false
		player = null
		$Price/CenterContainer/Popup.hide()
