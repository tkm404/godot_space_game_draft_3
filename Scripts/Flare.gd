extends Pickup


func _on_body_entered(body):
		if body is Player:
			body.collect(self)
			queue_free()
