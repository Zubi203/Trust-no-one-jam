class_name PlayerPossessionController
extends Node2D

signal SetDirection (dir: Vector2)
signal SetJump 
signal SetAction (dir: Vector2)
var enemy_movement: EnemyMovementComponent = null
var player: PlayerMovement = null
var facing_direction: Vector2


func _ready() -> void:
	_connect_signals.call_deferred()

func _connect_signals():
	var parent = get_parent()
	if parent == null:
		return
	if parent is EnemyMovementComponent:
		enemy_movement = parent
		SetAction.connect(enemy_movement.action_input)
		SetJump.connect(enemy_movement.jump_input)
		SetDirection.connect(enemy_movement.direction_input)

func get_input():
	var dir = Input. get_vector("move_left", "move_right", "move_up", "move_down")
	SetDirection.emit(dir)
	if dir:
		facing_direction = dir
	if Input.is_action_pressed("grab"):
		SetAction.emit(facing_direction)
	if Input.is_action_just_pressed("jump"):
		SetJump.emit()
	if Input.is_action_just_pressed("possess"):
		_end_possession()

func _process(delta: float) -> void:
	get_input()

func _end_possession():
	if player:
		player.enable_control(get_parent().global_position)
		player._jump()
		GameManager.SetCameraTarget.emit(player)
	SetDirection.emit(Vector2.ZERO)
	queue_free()
