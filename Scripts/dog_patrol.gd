extends State

var move_direction: Vector2 = Vector2.RIGHT
var aim_direction: Vector2
var is_moving: bool = true

func enter() -> void:
	is_moving = true
	if character_body is EnemyMovementComponent:
		character_body.speed_multiplier = 0.2
		if not character_body.SoundHeard.is_connected(_transition_to_sus):
			character_body.SoundHeard.connect(_transition_to_sus)
		if not character_body.TargetSighted.is_connected(_transition_to_alert):
			character_body.TargetSighted.connect(_transition_to_alert)

func physics_update(delta: float) -> void:
	if character_body is EnemyMovementComponent:
		if not is_moving:
			move_direction = Vector2.ZERO
			character_body.direction_input(move_direction)
			return
		_check_path_end()
		character_body.direction_input(move_direction)
		aim_direction = move_direction
		_set_vision_cone(aim_direction)

func exit() -> void:
	is_moving = true
	move_direction = Vector2.ZERO
	character_body.direction_input(move_direction)
	aim_direction = move_direction
	_set_vision_cone(aim_direction)

func _check_path_end():
	if character_body is EnemyMovementComponent:
		if not character_body.ledge_end_detector_left.is_colliding() or character_body.wall_detector_left.is_colliding():
			_on_change_direction(Vector2.RIGHT)
		if not character_body.ledge_end_detector_right.is_colliding() or character_body.wall_detector_right.is_colliding():
			_on_change_direction(Vector2.LEFT)

func _on_change_direction(dir: Vector2):
	if move_direction.x == dir.x:
		return
	is_moving = false
	await get_tree().create_timer(randf_range(0.5, 1)).timeout
	move_direction = dir
	is_moving = true

func _set_vision_cone(dir: Vector2):
	if character_body is EnemyMovementComponent:
		if character_body.vision_cone == null:
			return
		character_body.vision_cone.cone_direction = dir.normalized()

func _transition_to_sus():
	state_transition.emit(self, "suspicious")

func _transition_to_alert():
	state_transition.emit(self, "alert")
