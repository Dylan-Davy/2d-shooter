extends Control

func _on_Survival_pressed():
	get_tree().change_scene("res://UI/Menus/Menu.tscn")
	Game.ui.play()

func _on_Settings_pressed():
	get_tree().change_scene("res://UI/Menus/Settings.tscn")
	Game.ui.play()

func _on_Exit_pressed():
	get_tree().quit()
	Game.ui.play()
