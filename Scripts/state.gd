class_name State
extends Node

var animated_sprite: AnimatedSprite2D
var animation_player: AnimationPlayer
var character_body: CharacterBody2D
@export var animation_name: String

signal state_transition (source_state: State, new_state_name: String)

func enter() -> void:
	if animated_sprite:
		animated_sprite.play(animation_name.to_lower())

func exit() -> void:
	pass

func update(delta: float) -> void:
	pass

func physics_update(delta: float) -> void:
	pass
