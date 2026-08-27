extends Button

@export var type: GameManager.Scenes

func _ready() -> void:
	pressed.connect(_on_pressed)
	var string: String = GameManager.Scenes.find_key(type)
	text = string.replace("_", " ")

func _on_pressed():
	SceneTransition.transition(type, GameManager.current_scene)
