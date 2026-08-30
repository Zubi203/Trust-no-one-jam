class_name PlayerVisuals
extends Node2D

enum PlayerVisualStates{
	IDLE,
	WALKING,
	JUMP_WINDUP,
	JUMPING,
	LANDING_RECOVERY,
	SHOOTING,
	FLYING,
	HIT_WALL,
	POSSESS,
	DISAPPEAR,
}

@onready var main_animations = $"Main animations" as AnimatedSprite2D

signal finished_player_visual_animation(anim_name: String)

var _curr_anim_name : String

func toggle_player_visuals(visual_state : PlayerVisuals):
	match visual_state:
		PlayerVisualStates.IDLE:
			main_animations.play("idle")
		PlayerVisualStates.WALKING:
			main_animations.play("walk")
		PlayerVisualStates.JUMP_WINDUP:
			main_animations.play("jump wind up")
		PlayerVisualStates.JUMPING:
			main_animations.play("jumping")
		PlayerVisualStates.LANDING_RECOVERY:
			main_animations.play("landing")
		PlayerVisualStates.SHOOTING:
			main_animations.play("shoot")
		PlayerVisualStates.FLYING:
			main_animations.play("flying")
		PlayerVisualStates.HIT_WALL:
			main_animations.play("hit wall")
		PlayerVisualStates.POSSESS:
			main_animations.play("possess")
		PlayerVisualStates.DISAPPEAR:
			main_animations.play("disappear")
	
	_curr_anim_name = main_animations.animation

func _on_main_animations_animation_finished():
	finished_player_visual_animation.emit(_curr_anim_name)
