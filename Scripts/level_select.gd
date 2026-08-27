extends Control

func _on_back_button_pressed() -> void:
	SceneTransition.transition(GameManager.Scenes.TITLE, GameManager.current_scene)


func _on_settings_button_pressed() -> void:
	GameManager.ShowSettingsMenu.emit()
