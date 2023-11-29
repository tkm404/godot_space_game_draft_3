extends "res://Scripts/enemy_basic.gd"


@export var ENEMY_LASER_SCENE: PackedScene



@onready var shoot_timer = $ShootTimer
@onready var enemy_muzzle = $EnemyMuzzle
@onready var hull_damage_anim = $HullDamageAnim
@onready var shield_break_anim = $ShieldBreakAnim
@onready var destroyed_anim = $DestroyedAnim
@onready var body_sprite = $BodySprite


func _on_timer_timeout():
	var enemy_laser = ENEMY_LASER_SCENE.instantiate()
	enemy_laser.global_position = enemy_muzzle.global_position
	get_tree().root.add_child(enemy_laser)


func _on_body_entered(body):
	if body is Player:
		print("collision!")
		body.take_damage(25)
		take_damage(25)


func _on_hull_damaged():
	hull_damage_anim.visible = true
	hull_damage_anim.play("default")


func _on_hull_damage_anim_animation_finished():
	hull_damage_anim.stop()
	hull_damage_anim.visible = false


func _on_shield_broke():
	shield_break_anim.visible = true
	shield_break_anim.play("default")


func _on_shield_break_anim_animation_finished():
	shield_break_anim.stop()
	shield_break_anim.visible = false


func _on_unit_destroyed():
	body_sprite.visible = false
	destroyed_anim.visible = true
	destroyed_anim.play("default")


func _on_destroyed_anim_animation_finished():
	destroyed_anim.stop()
	destroyed_anim.visible = false
	queue_free()
