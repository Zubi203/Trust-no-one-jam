extends CanvasLayer

@export var pause_menu: Control

func _on_pause_button_pressed() -> void:
	if pause_menu:
		pause_menu.show()
		Engine.time_scale = 0


func _on_resume_button_pressed() -> void:
	if pause_menu:
		pause_menu.hide()
		Engine.time_scale = 1


func _on_settings_button_2_pressed() -> void:
	GameManager.ShowSettingsMenu.emit()


func _on_level_select_button_3_pressed() -> void:
	Engine.time_scale = 1.0
	SceneTransition.transition(GameManager.Scenes.LEVEL_SELECT, GameManager.current_scene)
