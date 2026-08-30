class_name PossessProjectile
extends CharacterBody2D

@export var speed_curve: Curve
var direction: Vector2 = Vector2.RIGHT
@export var move_speed: float = 250
@export var max_range: float =  150
var tether_point: Vector2
var player_controller: PlayerMovement = null

var dash_control_duration_percent: float = 0.6
var dash_control_timer: Timer
var has_control: bool = false

func set_projectile(pos: Vector2, dir: Vector2, player: PlayerMovement):
	global_position = pos
	tether_point = pos
	direction = dir
	player_controller = player
	has_control = false
	dash_control_timer = $DashControlTimer
	dash_control_timer.start(dash_control_duration_percent * $DestroyTimer.wait_time)


func _physics_process(_delta: float) -> void:
	move_speed = move_speed * speed_curve.sample(1 - ($DestroyTimer.time_left / $DestroyTimer.wait_time))
	velocity = direction * move_speed
	rotation = direction.angle()
	if has_control:
		velocity.y += 50
	move_and_slide()
	

func _process(_delta: float) -> void:
	if has_control:
		_get_input(_delta)

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

func _disable_collider():
	$CollisionShape2D.disabled = true


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body == player_controller:
		return
	if body.is_in_group("Enemy"):
		_disable_collider.call_deferred()
		if body is EnemyMovementComponent:
			var possessed = body.try_possess_enemy()
			if possessed:
				GameManager.SetCameraTarget.emit(body as Node2D)
				_possess()
			else:
				_destroy()
		return


func _on_destroy_timer_timeout() -> void:
	_destroy()


func _on_dash_control_timer_timeout() -> void:
	has_control = true
