extends State

@export var line_of_sight_break_delay: float = 1
var line_of_sight_countdown: float = 0
var move_direction: Vector2 = Vector2.ZERO
var aim_direction: Vector2 = Vector2.ZERO

@export var attack_range: float = 200
@export var close_range: float = 70

@export var jump_cooldown: float = 1
var last_jump_time: float = 0

func enter() -> void:
	if character_body is EnemyMovementComponent:
		character_body.speed_multiplier = 1.2

func physics_update(delta: float) -> void:
	if character_body is EnemyMovementComponent:
		if character_body.target_body == null:
			character_body._target_defeated()
			state_transition.emit(self, "patrol")
			return
		
		var dist_from_target: float = character_body.global_position.distance_to(character_body.target_body.global_position)
		if dist_from_target < attack_range and character_body._has_line_of_sight():
			aim_direction = character_body.global_position.direction_to(character_body.target_body.global_position)
			_set_vision_cone(aim_direction)
			character_body.action_input(aim_direction)
		else:
			_try_move_to_target()
		
		if character_body._has_line_of_sight():
			line_of_sight_countdown = line_of_sight_break_delay
		else:
			if line_of_sight_countdown > 0:
				line_of_sight_countdown -= delta
			else:
				character_body.target_point = character_body.target_body.global_position
				state_transition.emit(self, "suspicious")

func _try_move_to_target():
	if character_body is EnemyMovementComponent:
		var target_pos: Vector2 = character_body.target_body.global_position
		move_direction = Vector2.RIGHT if character_body.global_position.x < target_pos.x else Vector2.LEFT
		character_body.direction_input(move_direction)

func exit():
	if character_body is EnemyMovementComponent:
		move_direction = Vector2.ZERO
		character_body.direction_input(move_direction)

func _set_vision_cone(dir: Vector2):
	if character_body is EnemyMovementComponent:
		if character_body.vision_cone == null:
			return
		character_body.vision_cone.cone_direction = dir.normalized()

func _check_wall():
	if character_body is EnemyMovementComponent:
		if character_body.wall_detector_left.is_colliding() and move_direction == Vector2.LEFT:
			_try_jump()
		if character_body.wall_detector_right.is_colliding() and move_direction == Vector2.RIGHT:
			_try_jump()

func _check_ledge():
	if character_body is EnemyMovementComponent:
		if not character_body.ledge_end_detector_left.is_colliding() and move_direction == Vector2.LEFT:
			if character_body.target_point.y < character_body.global_position.y + 20:
				_try_jump()
		if not character_body.ledge_end_detector_right.is_colliding() and move_direction == Vector2.RIGHT:
			if character_body.target_point.y < character_body.global_position.y + 20:
				_try_jump()

func _try_jump():
	var time = Time.get_unix_time_from_system()
	if time - last_jump_time < jump_cooldown:
		return
	last_jump_time = time
	if character_body is EnemyMovementComponent:
		character_body.jump_input()
