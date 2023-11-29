extends Area2D
class_name Laser


@export var speed: int = 500

var direction: Vector2 = Vector2()


func _physics_process(delta):
	global_position.y += -speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_entered(area):
	if area is Enemy:
		area.take_laser_damage(25)
		queue_free()

