extends Node

signal BeginEscape
signal EmitSound (emission_pos: Vector2, range: float)
signal EnablePlayerControl (target_point: Vector2)
signal ShakeCamera (intensity: float)
signal SetCameraTarget (target: Node2D)

enum ProjectileTypes {
	PIERCE,
	BOUNCE,
	EXPLODE
}

const MAX_CLONE_COUNT: int = 20
