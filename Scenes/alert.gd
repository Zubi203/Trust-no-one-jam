extends State

@export var explode_range: float = 20

var movement_start: bool = false
var move_direction: Vector2 = Vector2.ZERO

func enter() -> void:
	movement_start = false
	if character_body is EnemyMovementComponent:
		character_body.play_sound(character_body.alert_sound)
		character_body.jump_input()
		character_body.speed_multiplier = 5
		await get_tree().create_timer(1).timeout
		if character_body.target_body == null:
			state_transition.emit(self, "suspicious")
			return
		move_direction = Vector2.RIGHT if character_body.global_position.x < character_body.target_body.global_position.x else Vector2.LEFT
		movement_start = true

func physics_update(delta: float) -> void:
	if not movement_start:
		return
	if character_body is EnemyMovementComponent:
		character_body.direction_input(move_direction)
		_set_vision_cone(move_direction)
		_check_target_dist()
		_check_wall()

func _check_target_dist():
	if character_body is EnemyMovementComponent:
		if character_body.target_body == null:
			state_transition.emit(self, "suspicious")
			return
		var dist = character_body.global_position.distance_to(character_body.target_body.global_position)
		if dist < explode_range:
			_try_explode()
			return

func _check_wall():
	if character_body is EnemyMovementComponent:
		if character_body.wall_detector_left.is_colliding() and move_direction == Vector2.LEFT:
			_try_explode()
			return
		if character_body.wall_detector_right.is_colliding() and move_direction == Vector2.RIGHT:
			_try_explode()
			return


func _try_explode():
	move_direction = Vector2.ZERO
	if character_body is EnemyMovementComponent:
		character_body.direction_input(move_direction)
	if character_body.has_method("explode"):
		character_body.explode()

func _set_vision_cone(dir: Vector2):
	if character_body is EnemyMovementComponent:
		if character_body.vision_cone == null:
			return
		character_body.vision_cone.cone_direction = dir.normalized()
