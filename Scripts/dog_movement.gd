extends GroundedEnemyMovement

@export var explode_sound_range: float = 300
@export var explosion_scene: PackedScene
@onready var mech_crab_visuals = $MechCrabVisuals as MechCrabVisuals

func explode():
	for child in get_children():
		if child is SoundEmitterComponent:
			child.emit_sound(300)
	await get_tree().create_timer(0.05).timeout
	if explosion_scene:
		var boom = explosion_scene.instantiate()
		boom.global_position = global_position
		get_tree().current_scene.add_child.call_deferred(boom)
	queue_free()

func action_input(dir: Vector2):
	explode()

func _process(_delta: float) -> void:
	
	if velocity.y > 0:
		mech_crab_visuals.toggle_jumping(true)
		return
	else: mech_crab_visuals.toggle_jumping(false)
	
	if velocity.length() > 0: mech_crab_visuals.toggle_walking_animation(true)
	else: mech_crab_visuals.toggle_walking_animation(false)
	
	if velocity.x > 0: mech_crab_visuals.scale.x = -1
	else: mech_crab_visuals.scale.x = 1
	
