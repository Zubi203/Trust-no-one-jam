class_name SoundEmitterComponent
extends Node2D

var radius: float = 1
var should_draw_circle: bool = false

func emit_sound(range: float):
	radius = range
	should_draw_circle = true
	queue_redraw()
	GameManager.EmitSound.emit(get_parent().global_position, range)
	await get_tree().create_timer(0.15).timeout
	should_draw_circle = false
	queue_redraw()

func _draw() -> void:
	if should_draw_circle:
		var color = Color.WHITE
		color.a = 0.1
		draw_circle(position, radius, color)
