class_name EnemyHumanVisuals
extends Node2D

# Just rotates upper to look at a specific point. When possessed this should be mouse

var _posessed := true
@onready var _upper_body = $Upper

@onready var walking_animation = $"Walking bottom/Walking" as AnimationPlayer
@onready var standing_bottom = $"Standing bottom" as Node2D
@onready var walking_bottom = $"Walking bottom" as Node2D

func toggle_walking(is_walking : bool):
	if is_walking:
		walking_animation.play("walking")
		walking_bottom.visible = true
		standing_bottom.visible = false
	else:
		walking_bottom.visible = false
		standing_bottom.visible = true
		if walking_animation.is_playing():
			walking_animation.stop()
