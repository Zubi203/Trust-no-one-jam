extends Node

@warning_ignore_start("unused_signal")
signal EmitSound (emission_pos: Vector2, range: float)
signal EnablePlayerControl (target_point: Vector2)
signal ShakeCamera (intensity: float)
signal SetCameraTarget (target: Node2D)
signal ShowSettingsMenu
signal HideSettingsMenu
signal PossessionEnd (pos: Vector2)
signal PlayerDefeated 

enum ProjectileTypes {
	PIERCE,
	BOUNCE,
	EXPLODE
}
enum Scenes {
	TITLE,
	LEVEL_SELECT,
	LEVEL_1,
	LEVEL_2,
	LEVEL_3,
	LEVEL_4,
	LEVEL_5,
	LEVEL_6
}
var current_scene: Scenes
const SCENE_PATHS: Dictionary[Scenes, String] = {
	Scenes.TITLE: "uid://b1axeffq6ci6j",
	Scenes.LEVEL_SELECT: "uid://bn680qg8um0nn",
	Scenes.LEVEL_1: "uid://rew3i22algr4",
	Scenes.LEVEL_2: "uid://ftygoenq1x0i",
	Scenes.LEVEL_3: "uid://bla2rsfxadmio",
	Scenes.LEVEL_4: "uid://cjrgmly40eurd",
	Scenes.LEVEL_5: "uid://5xwblun4mhpr",
	Scenes.LEVEL_6: "uid://bpuuciaulhhts"
}
