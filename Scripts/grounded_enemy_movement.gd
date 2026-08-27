extends EnemyMovementComponent

@export var gravity: float = 10

func move(delta: float):
	if direction:
		velocity.x = direction.x * move_speed
	else:
		velocity.x = 0
	if not is_on_floor():
		velocity.y += gravity

func _process(delta: float) -> void:
	pass
