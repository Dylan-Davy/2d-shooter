extends StaticBody2D
var can_activate = false
var entered_player
var power = false
signal power_on

func _process(delta):
	if can_activate and Input.is_action_just_pressed("interact") and not power:
		emit_signal("power_on")
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Players") and body.is_network_master():
		entered_player = body
		can_activate = true

func _on_Area2D_body_exited(body):
	if body == entered_player:
		can_activate = false
		entered_player = null
