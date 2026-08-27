class_name EnemyMovementComponent
extends CharacterBody2D

@export var move_speed: float = 200
var direction: Vector2

func direction_input(dir: Vector2):
	direction = dir

func action_input(dir: Vector2):
	pass

func jump_input():
	pass

func move(delta: float):
	pass

func _physics_process(delta: float) -> void:
	move(delta)
	move_and_slide()
