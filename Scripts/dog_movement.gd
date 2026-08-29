extends GroundedEnemyMovement

@export var explode_sound_range: float = 300

func explode():
	for child in get_children():
		if child is SoundEmitterComponent:
			child.emit_sound(300)
	await get_tree().create_timer(0.1).timeout
	queue_free()

func action_input(dir: Vector2):
	explode()
