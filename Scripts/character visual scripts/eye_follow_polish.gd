extends Sprite2D

@export var player : PlayerMovement
@onready var eye_ball = $"Eye ball" as Sprite2D

var _eye_tween : Tween

const _EYE_TARGET_DISTANCE = 10
func _process(_delta):
	_move_eye_position()
	
func _move_eye_position():
	# If tween is active
	if _eye_tween and _eye_tween.is_valid():
		return
	
	# Pick a random point
	var x_point = randf_range(-_EYE_TARGET_DISTANCE, _EYE_TARGET_DISTANCE)
	var y_point = randf_range(-_EYE_TARGET_DISTANCE, _EYE_TARGET_DISTANCE)
	var target_point = Vector2(x_point,y_point)
	
	_eye_tween = get_tree().create_tween()
	
	var random_look_time = randf_range(0.3,1)
	
	#eye_tween.tween_property(eye_sprite, "global_position",target_direction * _EYE_TARGET_DISTANCE, 0.5)
	_eye_tween.tween_method(_eye_step_method,eye_ball.position, target_point, random_look_time)

func _eye_step_method(target_position: Vector2):
	eye_ball.position = target_position.floor()
	
