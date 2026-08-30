extends Control

@export var title_menu: Control
@export var credits: Control

func _ready() -> void:
	MusicManager.menu_music.play()
	GameManager.ShowSettingsMenu.connect(hide_title_menu)
	GameManager.HideSettingsMenu.connect(show_title_menu)

func _on_play_button_pressed() -> void:
	SceneTransition.transition(GameManager.Scenes.LEVEL_1, GameManager.Scenes.TITLE)


func _on_settings_button_pressed() -> void:
	GameManager.ShowSettingsMenu.emit()
	


func _on_credits_button_pressed() -> void:
	if credits:
		credits.show()
		hide_title_menu()


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func hide_title_menu():
	if title_menu:
		title_menu.hide()

func show_title_menu():
	if title_menu:
		title_menu.show()


func _on_credits_close_button_pressed() -> void:
	if credits:
		credits.hide()
		show_title_menu()
