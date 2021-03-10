extends Control

func _ready():
	if OS.window_fullscreen == true:
		get_node("FullscreenCheck").pressed = true
	$MasterSlider.value = Game.music.volume_db
	
func _on_Back_pressed():
	get_tree().change_scene("res://UI/Menus/MainMenu.tscn")
	Game.ui.play()

func _on_Save_pressed():
	if get_node("FullscreenCheck").pressed == false:
		OS.window_fullscreen = false
	else:
		OS.window_fullscreen = true
	
	Game.music.volume_db = $MasterSlider.value
	Game.ui.volume_db = $MasterSlider.value
	
	Game.ui.play()
	
	get_tree().change_scene("res://UI/Menus/MainMenu.tscn")
