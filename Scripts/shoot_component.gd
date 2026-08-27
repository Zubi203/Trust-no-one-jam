class_name ShootProjectileComponent
extends Node2D

@export var projectile_data_paths: Dictionary[GameManager.ProjectileTypes, String] = {
	GameManager.ProjectileTypes.PIERCE: "uid://dlsob3bmxtstw",
	GameManager.ProjectileTypes.BOUNCE: "",
	GameManager.ProjectileTypes.EXPLODE: ""
}

func shoot(type: GameManager.ProjectileTypes, target_direction: Vector2):
	var owner_body = get_parent()
	var projectile: ProjectileBase = load(projectile_data_paths[type]).scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	projectile.set_projectile(owner_body, global_position, target_direction)
