extends Control

var menu_open = false

func _process(delta):
	if Input.is_action_just_pressed("pause") and menu_open == false:
		get_parent().get_parent().parent_can_fire = false
		$Popup.popup_centered()
		menu_open = true
	elif Input.is_action_just_pressed("pause") and menu_open == true:
		get_parent().get_parent().parent_can_fire = true
		$Popup.hide()
		$Settings.hide()
		menu_open = false
		
func _on_Resume_pressed():
	$Popup.hide()
	get_parent().get_parent().parent_can_fire = true
	menu_open = false
	Game.ui.play()

func _on_Settings_pressed():
	if OS.window_fullscreen == true:
		get_node("Settings/FullscreenCheck").pressed = true
	
	Game.ui.play()
	$Settings/MasterSlider.value = Game.music.volume_db
	
	$Popup.hide()
	$Settings.popup_centered()

func _on_Leave_pressed():
	$Popup.hide()
	menu_open = false
	Game.ui.play()
	Network.leave_server()

func _on_Save_pressed():
	if get_node("Settings/FullscreenCheck").pressed == false:
		OS.window_fullscreen = false
	else:
		OS.window_fullscreen = true
		
	get_parent().get_parent().parent_can_fire = true
	Game.music.volume_db = $Settings/MasterSlider.value
	Game.ui.volume_db = $Settings/MasterSlider.value
	Game.ui.play()
	menu_open = false
	$Settings.hide()

func _on_Exit_pressed():
	menu_open = false
	get_parent().get_parent().parent_can_fire = true
	Game.ui.play()
	$Settings.hide()
