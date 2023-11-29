extends "res://Scripts/laser.gd"



func _physics_process(delta):
	global_position.y += -speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Enemy:
		area.take_laser_damage(10)
		queue_free()

