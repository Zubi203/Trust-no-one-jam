class_name EnemyEyeVisuals
extends Node2D

## Just contains a few functions that alter the visuals of the eye enemy
## This includes:
##
## increment_vein_color()
## move_eye_position()
## change_visual_state()

# References
@onready var eye_sprite = $Visuals/Eye as Sprite2D
@onready var eye_vein_sprite = $Visuals/veins/Sprite2D as Sprite2D
@onready var animated_eye_close = $"Visuals/Animated Eye Close" as AnimatedSprite2D
@onready var eye_animation = $Eye_animation as AnimationPlayer

# Local variables
var _is_in_mouth_mode := false
var _eye_tween : Tween

# Constants
const _EYE_TARGET_DISTANCE := 5.0
const _FLYING_ENEMY_MOUTH = preload("uid://dh76p80rbf23")

func _ready():
	transform_into_mouth()

func _process(delta):
	
	update_eye_movement(get_global_mouse_position())
	
	# Some rounding for a quick ghetto fix for pixel movement
	eye_sprite.global_position = eye_sprite.global_position.floor()

func update_eye_movement(target_position: Vector2):
	if !_is_in_mouth_mode: _move_eye_position(target_position)
	else: _move_mouth_position(target_position)

# A basic tween function to target position will move eye veins and does not work
# in mouth mode
func _move_eye_position(target_position : Vector2):
	# Check if in mouth mode
	if _is_in_mouth_mode:
		printerr("Cannot change eye position of eye enemy while in mouth mode, source: " + name)
		return
	# If tween is active
	if _eye_tween and _eye_tween.is_running():
		return
	
	_eye_tween = get_tree().create_tween()
	var target_direction = global_position.direction_to(target_position)
	
	#eye_tween.tween_property(eye_sprite, "global_position",target_direction * _EYE_TARGET_DISTANCE, 0.5)
	_eye_tween.tween_method(_eye_step_method,eye_sprite.global_position, target_direction * _EYE_TARGET_DISTANCE, 0.1)

func _move_mouth_position(target_position: Vector2):
	# Just rotate towards position, negative since my ass drew everything facing left instead of right.
	rotation = global_position.angle_to_point(-target_position)

func _eye_step_method(target_position: Vector2):
	eye_sprite.global_position = target_position.floor()
	eye_vein_sprite.global_position = eye_sprite.global_position

## So far there is no visual function to reverse this but it shouldn't be too hard
func transform_into_mouth():
	eye_animation.play("transform_into_mouth")
	animated_eye_close.play("close_eye")
	
func _on_eye_animation_animation_finished(anim_name):
	if anim_name == "transform_into_mouth":
		_is_in_mouth_mode = true
