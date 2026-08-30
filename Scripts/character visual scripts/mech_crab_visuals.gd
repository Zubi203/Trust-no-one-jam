class_name MechCrabVisuals
extends Node2D

@onready var walking = $Walking as AnimatedSprite2D
@onready var standing = $Standing as Sprite2D
@onready var jump_frame = $"Jump frame" as Sprite2D

func toggle_walking_animation(is_walking : bool):
	if is_walking:
		walking.play("default")
		walking.visible = true
		standing.visible = false
	else:
		standing.visible = true
		walking.visible = false

func toggle_jumping(is_jumping : bool):
	if is_jumping:
		standing.visible = false
		walking.visible = false
		jump_frame.visible = true
	else:
		jump_frame.visible = false
		toggle_walking_animation(false)
