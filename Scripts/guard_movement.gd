extends GroundedEnemyMovement

@export var shoot_interval: float = 0.1
var last_shoot_time: float
var shoot_component: ShootProjectileComponent = null
@export var reload_timer: Timer
@export var reload_duration: float = 1.2
@export var mag_size: int = 6
var current_mag: int
@export var reload_timer_progress_bar: Range

func _enemy_ready():
	current_mag = mag_size
	for child in get_children():
		if child is ShootProjectileComponent:
			shoot_component = child
	if reload_timer_progress_bar:
		reload_timer_progress_bar.max_value = reload_duration

func action_input(dir: Vector2):
	_try_shoot_bullet(dir)

func _try_shoot_bullet(dir: Vector2):
	if reload_timer == null:
		return
	if reload_timer.time_left:
		return
	if shoot_component == null:
		return
	var time = Time.get_unix_time_from_system()
	if time - last_shoot_time < shoot_interval:
		return
	last_shoot_time = time
	shoot_component.shoot(GameManager.ProjectileTypes.PIERCE, dir)
	
	if current_mag > 0:
		current_mag -= 1
	else:
		current_mag = mag_size
		reload_timer.start(reload_duration)

func _process(_delta: float) -> void:
	if reload_timer_progress_bar:
		reload_timer_progress_bar.value = reload_timer.time_left
