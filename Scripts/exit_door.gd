extends StaticBody2D


func _ready() -> void:
	GameManager.BeginEscape.connect(_open_door)


func _open_door():
	hide()
