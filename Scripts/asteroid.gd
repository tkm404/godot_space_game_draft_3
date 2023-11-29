extends "res://Scripts/enemy_basic.gd"

@onready var hull_damaged_anim = $HullDamagedAnim
@onready var destroyed_anim = $DestroyedAnim
@onready var asteroid_sprite = $AsteroidSprite



func _on_body_entered(body):
	if body is Player:
		print("asteroid collision!")
		body.take_damage(50)
		take_damage(25)


func _on_hull_damaged():
	hull_damaged_anim.visible = true
	hull_damaged_anim.play("default")


func _on_unit_destroyed():
	asteroid_sprite.visible = false
	destroyed_anim.visible = true
	destroyed_anim.play("default")


func _on_hull_damaged_anim_animation_finished():
	hull_damaged_anim.stop()
	hull_damaged_anim.visible = false


func _on_destroyed_anim_animation_finished():
	destroyed_anim.stop()
	destroyed_anim.visible = false
	queue_free()
