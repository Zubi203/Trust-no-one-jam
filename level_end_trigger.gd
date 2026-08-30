extends Area2D

@export var target_level: GameManager.Scenes

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		SceneTransition.transition(target_level, GameManager.current_scene)
