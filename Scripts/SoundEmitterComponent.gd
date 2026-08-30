class_name SoundEmitterComponent
extends Node2D

func emit_sound(sound_range: float):
	GameManager.EmitSound.emit(get_parent().global_position, sound_range)
