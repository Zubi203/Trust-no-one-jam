class_name SoundDetectorComponent
extends Node2D

signal SoundDetected (target_point: Vector2)

func _ready() -> void:
	GameManager.EmitSound.connect(_on_sound_signal_detected)

func _on_sound_signal_detected(pos: Vector2, range: float):
	var distance_from_sound = global_position.distance_to(pos)
	if distance_from_sound <= range:
		await get_tree().create_timer(0.5).timeout
		SoundDetected.emit(pos)
