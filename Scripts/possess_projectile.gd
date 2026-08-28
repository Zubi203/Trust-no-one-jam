class_name PossessProjectile
extends Area2D

var direction: Vector2 = Vector2.RIGHT
@export var move_speed: float = 250
@export var max_range: float =  150
var tether_point: Vector2
var player_controller: PlayerMovement = null

func set_projectile(pos: Vector2, dir: Vector2, player: PlayerMovement):
	global_position = pos
	tether_point = pos
	direction = dir
	player_controller = player

func _physics_process(delta: float) -> void:
	translate(direction * move_speed * delta)
	rotation = direction.angle()

func _process(_delta: float) -> void:
	_get_input(_delta)
	_check_tether_distance()
	pass

func _get_input(delta: float):
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dir:
		direction = direction.lerp(dir, delta * 10)

func _destroy():
	GameManager.EnablePlayerControl.emit(global_position)
	GameManager.SetCameraTarget.emit(player_controller)
	queue_free()

func _possess():
	player_controller.hide()
	queue_free()

func _check_tether_distance():
	var dist = global_position.distance_to(tether_point)
	if dist > max_range:
		_destroy()


func _on_body_entered(body: Node2D) -> void:
	if body == player_controller:
		return
	if body.is_in_group("Enemy"):
		var controller = PlayerPossessionController.new()
		body.add_child(controller)
		controller.player = player_controller
		GameManager.SetCameraTarget.emit(body)
		_possess()
		return
	_destroy()
