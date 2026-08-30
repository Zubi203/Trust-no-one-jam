class_name PlayerMovement
extends CharacterBody2D

enum MoveStates {
	NORMAL,
	WALL,
	CEILING
}
var current_state: MoveStates

@export_category("Movement")
var control_enabled: bool = true
@export var move_speed: float = 350
@export var wall_climb_speed: float = 200
@export var wall_kick_horizontal_force: float = 600
@export var ceiling_climb_speed: float = 200
@export var acceleration: float = 350
@export var braking: float = 500
var direction_x: float
var direction_y: float
var facing_direction: float
var was_on_floor: bool = false

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

@export_category("Sounds")
var sound_emitter: SoundEmitterComponent = null
@export var jump_volume: float = 200
@export var max_landing_volume: float = 300
@export var footsteps_volume: float = 100
@export var wall_and_ceiling_volume: float = 70
@export var footsteps_interval: float = 0.2
var last_footstep_time: float = 0

@export var audio: AudioStreamPlayer2D
@export var possession_exit_sound: AudioStream
@export var possession_enter_sound: AudioStream

@export_category("Possess")
@export var possess_projectile: PackedScene
@export var possess_cooldown_timer: Timer
@export var possess_cooldown_duration: float = 3
@export var possess_cooldown_timer_bar: Range
@export var collider: CollisionShape2D = null

@export_category("Visuals")
var sprite: Sprite2D = null
var base_sprite_scale: Vector2

func _ready() -> void:
	GameManager.PossessionEnd.connect(enable_control_jump)
	GameManager.SetCameraTarget.emit.call_deferred(self)
	GameManager.EnablePlayerControl.connect(enable_control)
	for child in get_children():
		if child is SoundEmitterComponent:
			sound_emitter = child
		if child is Sprite2D:
			sprite = child
			base_sprite_scale = sprite.scale
	if possess_cooldown_timer_bar:
		possess_cooldown_timer_bar.max_value = possess_cooldown_duration


func _physics_process(delta: float) -> void:
	_get_input(delta)
	_move(delta)
	move_and_slide()

func _process(_delta: float) -> void:
	
	if sprite:
		sprite.flip_h = facing_direction < 0
	_moving_sounds()
	
	if is_on_floor() and not was_on_floor:
		_on_landing()
	was_on_floor = is_on_floor()
	
	if possess_cooldown_timer_bar and possess_cooldown_timer:
		possess_cooldown_timer_bar.value = possess_cooldown_timer.time_left


func _get_input(delta: float):
	if not control_enabled:
		return
	
	direction_x = Input.get_axis("move_left", "move_right")
	direction_y = Input.get_axis("move_up", "move_down")
	
	match current_state:
		MoveStates.NORMAL:
			
			if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer.time_left):
				_jump()
			if Input.is_action_just_released("jump") and velocity.y < 0:
				velocity.y = move_toward(velocity.y, velocity.y / 4, delta * jump_cut_damping_rate)
			
			if Input.is_action_pressed("grab"):
				if is_on_ceiling_only():
					current_state = MoveStates.CEILING
				elif is_on_wall():
					current_state = MoveStates.WALL
			
			if Input.is_action_just_pressed("possess"):
				_try_shoot_projectile()
		MoveStates.WALL:
			
			if Input.is_action_just_pressed("jump"):
				current_state = MoveStates.NORMAL
				_jump()
				velocity.x = wall_kick_horizontal_force * -facing_direction
			
			if Input.is_action_just_released("grab"):
				current_state = MoveStates.NORMAL
			if not is_on_wall():
				current_state = MoveStates.NORMAL
		MoveStates.CEILING:
			
			if Input.is_action_just_pressed("jump"):
				current_state = MoveStates.NORMAL
			
			if Input.is_action_just_released("grab"):
				current_state = MoveStates.NORMAL
			if not is_on_ceiling():
				current_state = MoveStates.NORMAL

func _move(delta: float):
	
	match current_state:
		MoveStates.NORMAL:
			if direction_x:
				facing_direction = direction_x
				velocity.x = move_toward(velocity.x, direction_x * move_speed, acceleration * delta)
			else:
				velocity.x = move_toward(velocity.x, 0.0, braking * delta)
			if not is_on_floor():
				velocity.y += _get_custom_gravity() * delta
		MoveStates.WALL:
			if direction_y:
				velocity.y = direction_y * wall_climb_speed
			else:
				velocity.y = direction_y * wall_climb_speed
		MoveStates.CEILING:
			if direction_x:
				velocity.x = direction_x * ceiling_climb_speed
			else:
				velocity.x = direction_x * ceiling_climb_speed
	
	
	if on_floor != is_on_floor() and velocity.y >= 0:
		if coyote_timer:
			coyote_timer.start(coyote_time_duration)
	on_floor = is_on_floor()

func _get_custom_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

func _try_emit_sound(sound_range: float):
	if sound_emitter == null:
		return
	sound_emitter.emit_sound(sound_range)

func _jump():
	velocity.y = jump_velocity
	_jump_animation()
	_try_emit_sound(jump_volume)

func _on_landing():
	_try_emit_sound(max_landing_volume)
	_landing_animation()

func _moving_sounds():
	var time = Time.get_unix_time_from_system()
	if time - last_footstep_time < footsteps_interval:
		return
	last_footstep_time = time
	
	match current_state:
		MoveStates.NORMAL:
			if direction_x and is_on_floor():
				_try_emit_sound(footsteps_volume)
		MoveStates.WALL:
			if direction_y:
				_try_emit_sound(wall_and_ceiling_volume)
		MoveStates.CEILING:
			if direction_x:
				_try_emit_sound(wall_and_ceiling_volume)

func _try_shoot_projectile():
	if possess_cooldown_timer == null:
		return
	if possess_cooldown_timer.time_left:
		return
	if possess_projectile == null:
		return
	var projectile: PossessProjectile = possess_projectile.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.set_projectile(global_position, Vector2(facing_direction, 0), self)
	GameManager.SetCameraTarget.emit(projectile)
	if possess_cooldown_timer_bar:
		possess_cooldown_timer_bar.value = possess_cooldown_duration
	disable_control()

func disable_control():
	play_sound(possession_exit_sound)
	GameManager.ShakeCamera.emit(1)
	set_process(false)
	set_physics_process(false)
	_disable_collider.call_deferred()
	control_enabled = false
	if visible:
		hide()

func enable_control(pos: Vector2):
	GameManager.ShakeCamera.emit(1)
	play_sound(possession_enter_sound)
	_enable_collider.call_deferred()
	if possess_cooldown_timer:
		possess_cooldown_timer.start(possess_cooldown_duration)
	GameManager.SetCameraTarget.emit(self)
	global_position = pos
	velocity = Vector2.ZERO
	set_process(true)
	set_physics_process(true)
	control_enabled = true
	if not visible:
		show()

func enable_control_jump(pos: Vector2):
	enable_control(pos)
	_jump()

func _landing_animation():
	if sprite == null:
		return
	sprite.scale = base_sprite_scale
	var base_offset = sprite.offset
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween.tween_property(sprite, "scale:x", base_sprite_scale.x + 0.2, 0.1)
	tween.tween_property(sprite, "scale:y", base_sprite_scale.y - 0.2, 0.1)
	tween.tween_property(sprite, "offset:y", base_offset.y + 6, 0.1)
	tween.set_parallel(false)
	tween.tween_interval(0.1)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween.tween_property(sprite, "scale:x", base_sprite_scale.x, 0.1)
	tween.tween_property(sprite, "scale:y", base_sprite_scale.y, 0.1)
	tween.tween_property(sprite, "offset:y", base_offset.y, 0.1)

func _jump_animation():
	if sprite == null:
		return
	sprite.scale = base_sprite_scale
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween.tween_property(sprite, "scale:x", base_sprite_scale.x - 0.2, 0.1)
	tween.tween_property(sprite, "scale:y", base_sprite_scale.y + 0.2, 0.1)
	tween.set_parallel(false)
	tween.tween_interval(0.1)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).set_parallel(true)
	tween.tween_property(sprite, "scale:x", base_sprite_scale.x, 0.1)
	tween.tween_property(sprite, "scale:y", base_sprite_scale.y, 0.1)

func _enable_collider():
	if collider == null:
		return
	collider.disabled = false

func _disable_collider():
	if collider == null:
		return
	collider.disabled = true

func play_sound(sound: AudioStream):
	if sound == null:
		return
	if audio == null:
		return
	audio.stream = sound
	audio.play()
