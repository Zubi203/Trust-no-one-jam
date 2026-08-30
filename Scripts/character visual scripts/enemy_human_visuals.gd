class_name EnemyHumanVisuals
extends Node2D

# Just rotates upper to look at a specific point. When possessed this should be mouse

var _posessed := true
@onready var _upper_body = $Upper

@onready var enemy_animations = $"enemy animations" as AnimationPlayer
@onready var standing_bottom = $"Feet/Standing feet" as Node2D
@onready var walking_bottom = $"Feet/walking feet" as Node2D
@onready var flying_feet = $"Feet/flying feet"
@onready var flying_jetpack = $"Jetpacks/flying jetpack"
@onready var jetpacks = $Jetpacks
@onready var walking_feet = $"Feet/walking feet" as AnimatedSprite2D

func look_at_target_pos(target_pos: Vector2):
	_upper_body.look_at(target_pos)
	jetpacks.look_at(target_pos)

func toggle_walking(is_walking : bool):
	if is_walking:
		enemy_animations.play("walking")
		walking_feet.play("walking")
		walking_bottom.visible = true
		standing_bottom.visible = false
	else:
		walking_bottom.visible = false
		standing_bottom.visible = true
		if enemy_animations.is_playing():
			enemy_animations.stop()

func toggle_flying(is_flying: bool):
	if is_flying:
		flying_feet.visible = true
		walking_bottom.visible = false
		standing_bottom.visible = false
		flying_jetpack.visible = true
	else:
		flying_feet.visible = false
		toggle_walking(false)
