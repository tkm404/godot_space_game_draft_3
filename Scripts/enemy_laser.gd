extends "res://Scripts/laser.gd"






func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.take_laser_damage(35)
		print(body.shields)
		print(body.hp)
		queue_free()
