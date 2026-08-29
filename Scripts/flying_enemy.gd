extends EnemyMovementComponent

@export var call_distance: float = 900
@export var acceleration: float = 350
@export var braking: float = 500
@export var sound_emitter_component: SoundEmitterComponent

@export var call_cooldown: float = 1
var last_call_time: float

func move(delta: float):
	if direction:
		velocity = velocity.move_toward(direction * move_speed * speed_multiplier, delta * acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * braking)

func action_input(dir: Vector2):
	_try_emit_sound()

func _try_emit_sound():
	if sound_emitter_component == null:
		return
	var time = Time.get_unix_time_from_system()
	if time - last_call_time < call_cooldown:
		return
	last_call_time = time
	sound_emitter_component.emit_sound(call_distance)
