class_name GroundedEnemyMovement
extends EnemyMovementComponent

@export var gravity: float = 10

@export var jump_height: float = 40
@export var jump_time_to_peak: float = 0.3
@export var jump_time_to_descent: float = 0.2

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0


func move(delta: float):
	if direction:
		velocity.x = direction.x * move_speed
	else:
		velocity.x = 0
	if not is_on_floor():
		velocity.y += _get_custom_gravity() * delta

func jump_input():
	if is_on_floor():
		velocity.y = jump_velocity

func _process(delta: float) -> void:
	pass

func _get_custom_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity
