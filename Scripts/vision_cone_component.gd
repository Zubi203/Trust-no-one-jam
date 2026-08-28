class_name VisionConeComponent
extends Node2D

signal PlayerDetected

@export var fov_angle: float = 60
@export var cone_range: float = 100
var cone_direction: Vector2 = Vector2.RIGHT

var player: PlayerMovement = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _process(delta: float) -> void:
	if player == null:
		return
	if global_position.distance_to(player.global_position) > cone_range:
		return
	var looking_dir_angle: float = rad_to_deg(cone_direction.angle())
	var player_dir_angle: float = rad_to_deg(global_position.direction_to(player.global_position).angle())
	var abs_angle_difference = abs(looking_dir_angle - player_dir_angle)
	if abs_angle_difference < fov_angle / 2:
		PlayerDetected.emit()

func _draw():
	var center = position
	var radius = cone_range * 0.5
	var start_angle = cone_direction.angle() - deg_to_rad(fov_angle / 2)
	var end_angle = cone_direction.angle() + deg_to_rad(fov_angle / 2)
	var point_count = 32 
	var color = Color.WHITE
	color.a = 0.2
	var width = cone_range
	
	draw_arc(center, radius, start_angle, end_angle, point_count, color, width)
