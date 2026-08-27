extends GroundedEnemyMovement

@export var acceleration: float = 350
@export var braking: float = 500

func move(delta: float):
	if direction.x:
		velocity.x = move_toward(velocity.x, direction.x * move_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, braking * delta)
	if not is_on_floor():
		velocity.y += _get_custom_gravity() * delta
