class_name PlayerMovement
extends CharacterBody2D

@export var move_speed: float = 150
@export var acceleration: float = 350
@export var braking: float = 500
var direction_x: float

@export var coyote_time_duration: float = 0.3
@export var coyote_timer: Timer
var on_floor: bool
@export var jump_cut_damping_rate: float = 10000
@export var jump_height: float = 80
@export var jump_time_to_peak: float = 0.5
@export var jump_time_to_descent: float = 0.4

@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

var shoot_dir: Vector2
var selected_bullet: GameManager.ProjectileTypes
@export var projectile_cooldowns: Dictionary[GameManager.ProjectileTypes, float] = {
	GameManager.ProjectileTypes.PIERCE: 0.5,
	GameManager.ProjectileTypes.BOUNCE: 1,
	GameManager.ProjectileTypes.EXPLODE: 1.5
}
@export var shoot_cooldown_timer: Timer
var shoot_component: ShootProjectileComponent = null
@export var clone_scene: PackedScene
var escape_active: bool = false
var recoil_vector: Vector2 = Vector2.ZERO
@export var recoil_force: float = 600

func _ready() -> void:
	escape_active = false
	for child in get_children():
		if child is ShootProjectileComponent:
			shoot_component = child
	GameManager.BeginEscape.connect(_on_escape_begin)


func _physics_process(delta: float) -> void:
	_get_input(delta)
	_move(delta)
	move_and_slide()

func _get_input(delta: float):
	direction_x = Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer.time_left):
		velocity.y = jump_velocity
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = move_toward(velocity.y, velocity.y / 4, delta * jump_cut_damping_rate)
	if Input.is_action_just_pressed("shoot"):
		_try_shoot_projectile()

func _move(delta: float):
	if direction_x:
		velocity.x = move_toward(velocity.x, direction_x * move_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, braking * delta)
	if not is_on_floor():
		velocity.y += _get_custom_gravity() * delta
	if on_floor != is_on_floor() and velocity.y >= 0:
		if coyote_timer:
			coyote_timer.start(coyote_time_duration)
	on_floor = is_on_floor()

func _get_custom_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _try_shoot_projectile():
	if escape_active:
		return
	if shoot_component == null:
		return
	if shoot_cooldown_timer == null:
		return
	
	if shoot_cooldown_timer.time_left:
		return
	shoot_cooldown_timer.start(projectile_cooldowns[selected_bullet])
	shoot_dir = global_position.direction_to(get_global_mouse_position())
	shoot_component.shoot(selected_bullet, shoot_dir)
	_try_spawn_clone()
	_recoil()

func _try_spawn_clone():
	if clone_scene == null:
		return
	var clone: Clone = clone_scene.instantiate()
	get_tree().current_scene.add_child(clone)
	clone.global_position = global_position
	
	var sprite: Sprite2D = null
	for child in get_children():
		if child is Sprite2D:
			sprite = child 
	
	clone.set_clone(sprite.texture, shoot_dir, selected_bullet)

func _on_escape_begin():
	escape_active = true

func _recoil():
	recoil_vector = shoot_dir * -1 * recoil_force
	velocity += recoil_vector

func _exit_tree() -> void:
	get_tree().quit()
