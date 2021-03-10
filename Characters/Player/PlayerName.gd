extends VBoxContainer

var my_player

func start(player):
	my_player = player
	$Label.text = player.player_name
	$TextureProgress.max_value = player.max_health
	
	if player.my_colour == 2:
		$Label.set("custom_colors/font_color", Color("e80606"))
		$TextureProgress.set("tint_progress", Color("e80606"))
	elif player.my_colour == 3:
		$Label.set("custom_colors/font_color", Color("0419f8"))
		$TextureProgress.set("tint_progress", Color("0419f8"))
	elif player.my_colour == 4:
		$Label.set("custom_colors/font_color", Color("0be838"))
		$TextureProgress.set("tint_progress", Color("0be838"))

func _process(delta):
	self.rect_position = my_player.global_position + Vector2(-self.rect_size.x / 2, -70)
	$TextureProgress.value = my_player.slave_health
