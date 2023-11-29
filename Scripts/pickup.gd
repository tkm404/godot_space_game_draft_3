extends Area2D
class_name Pickup


@onready var collision_shape_2d = $CollisionShape2D


var launch_velocity : Vector2 = Vector2.ZERO
var move_duration : float = 0
var time_since_launch : float = 0
var launching : bool = false :
	set(is_launching):
		launching = is_launching
		
		collision_shape_2d.disabled = launching


func _process(delta):
	if(launching):
		position += launch_velocity * delta
		time_since_launch += delta
		
		if(time_since_launch >= move_duration):
			launching = false


func _on_body_entered(body):
		if body is Player:
			body.collect(self)
			queue_free()


func launch(velocity : Vector2, duration : float):
	launch_velocity = velocity
	move_duration = duration
	time_since_launch = 0
	launching = true
