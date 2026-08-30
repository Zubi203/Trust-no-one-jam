extends State

var move_direction: Vector2 = Vector2.RIGHT
var aim_direction: Vector2
var is_moving: bool = true
@export var state_duration: float = 5
var duration_timer: float = 0
var movement_start: bool = false

@export var jump_cooldown: float = 1
var last_jump_time: float = 0

func enter() -> void:
	is_moving = true
	duration_timer = state_duration
	if character_body is EnemyMovementComponent:
		character_body.play_sound(character_body.suspicious_sound)
		if not character_body.TargetSighted.is_connected(_transition_to_alert):
			character_body.TargetSighted.connect(_transition_to_alert)
		aim_direction = character_body.global_position.direction_to(character_body.target_point)
		_set_vision_cone(Vector2(aim_direction.x, 0))
		character_body.speed_multiplier = 1
		if not character_body.SoundHeard.is_connected(_restart_timer):
			character_body.SoundHeard.connect(_restart_timer)
	await get_tree().create_timer(1).timeout
	movement_start = true

func physics_update(delta: float) -> void:
	if not movement_start:
		return
	
	if duration_timer > 0:
		duration_timer -= delta
	else:
		state_transition.emit(self, "patrol")
		return
	
	if character_body is EnemyMovementComponent:
		aim_direction = character_body.global_position.direction_to(character_body.target_point)
		_set_vision_cone(Vector2(aim_direction.x, 0))
		move_direction = Vector2.RIGHT if character_body.global_position.x < character_body.target_point.x else Vector2.LEFT
		character_body.direction_input(move_direction)
		_check_wall()
		_check_ledge()


func exit() -> void:
	move_direction = Vector2.ZERO
	character_body.direction_input(move_direction)
	aim_direction = move_direction
	_set_vision_cone(aim_direction)

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

func _restart_timer():
	duration_timer = state_duration

func _try_jump():
	var time = Time.get_unix_time_from_system()
	if time - last_jump_time < jump_cooldown:
		return
	last_jump_time = time
	if character_body is EnemyMovementComponent:
		character_body.jump_input()

func _transition_to_alert():
	state_transition.emit(self, "alert")
