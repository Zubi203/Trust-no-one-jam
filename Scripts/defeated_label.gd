extends Label

func _ready() -> void:
	GameManager.PlayerDefeated.connect(_on_player_defeated)

func _on_player_defeated():
	show()
	await get_tree().create_timer(1).timeout
	SceneTransition.transition(GameManager.current_scene, GameManager.current_scene)
