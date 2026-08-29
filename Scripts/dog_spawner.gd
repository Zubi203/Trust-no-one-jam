extends Node2D

@export var dog_scene: PackedScene
var current_dog: Node2D = null

func _try_spawn_dog():
	if dog_scene == null:
		return
	if current_dog != null:
		return
	var dog: Node2D = dog_scene.instantiate()
	add_child(dog)
	dog.global_position = global_position
	current_dog = dog


func _on_timer_timeout() -> void:
	_try_spawn_dog()
