extends Node

signal BeginEscape

enum ProjectileTypes {
	PIERCE,
	BOUNCE,
	EXPLODE
}

const MAX_CLONE_COUNT: int = 20
