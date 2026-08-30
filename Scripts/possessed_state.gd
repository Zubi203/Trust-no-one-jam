extends State

var move_direction: Vector2
var aim_direction: Vector2

func enter() -> void:
	GameManager.ShakeCamera.emit(2)
	if character_body is EnemyMovementComponent:
		character_body.speed_multiplier = 1

func update(delta: float) -> void:
	get_input()

func get_input():
	if character_body is EnemyMovementComponent:
		move_direction = Input. get_vector("move_left", "move_right", "move_up", "move_down")
		if move_direction:
			aim_direction = move_direction
			character_body.direction_input(move_direction)
		else :
			character_body.direction_input(Vector2.ZERO)
		_set_vision_cone(aim_direction)
		if Input.is_action_pressed("grab"):
			character_body.action_input(aim_direction)
		if Input.is_action_just_pressed("jump"):
			character_body.jump_input()
		if Input.is_action_just_pressed("possess"):
			_end_possession()

func _end_possession():
	if character_body is EnemyMovementComponent:
		character_body.direction_input(Vector2.ZERO)
	state_transition.emit(self, "stunned")
	GameManager.PossessionEnd.emit(character_body.global_position)

func _set_vision_cone(dir: Vector2):
	if character_body is EnemyMovementComponent:
		if character_body.vision_cone == null:
			return
		character_body.vision_cone.cone_direction = dir.normalized()
