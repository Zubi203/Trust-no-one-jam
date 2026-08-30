class_name LockedDoor
extends StaticBody2D


func open_door():
	$AnimationPlayer.play("open")

func _disable_collider():
	$CollisionShape2D.disabled = true

func _play_sound():
	$DoorAudio.play()
