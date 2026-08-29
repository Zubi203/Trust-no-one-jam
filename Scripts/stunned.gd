extends State

@export var stun_duration: float = 2

func enter() -> void:
	if character_body is EnemyMovementComponent:
		character_body.direction_input(Vector2.ZERO)
	await get_tree().create_timer(stun_duration).timeout
	_transition_to_patrol()

func _transition_to_patrol():
	state_transition.emit(self, "patrol")
