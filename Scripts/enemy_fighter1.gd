extends "res://Scripts/enemy_basic.gd"


@export var ENEMY_LASER_SCENE: PackedScene



@onready var shoot_timer = $ShootTimer
@onready var enemy_muzzle = $EnemyMuzzle
@onready var hull_damage_anim = $HullDamageAnim
@onready var shield_break_anim = $ShieldBreakAnim
@onready var destroyed_anim = $DestroyedAnim
@onready var body_sprite = $BodySprite
@onready var player = get_parent().get_node("Player")

var player_in_range
var player_in_sight


func _physics_process(delta):
	SightCheck()


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


func _on_radar_sight_body_entered(body):
	if body == player:
		player_in_range = true
		print("player in range: ", player_in_range)


func _on_radar_sight_body_exited(body):
	if body == player:
		player_in_range = false
		print("player_in_range: ", player_in_range)
		


func SightCheck():
	if player_in_range:
		var space_state = get_world_2d().direct_space_state
		var params = PhysicsRayQueryParameters2D.new()
		params.from = position
		params.to = player.position
		params.exclude = [self]
		params.collision_mask = collision_mask
		var sight_line = space_state.intersect_ray(params)
		if sight_line:
			if sight_line.collider.name == "Player":
				player_in_sight = true
				print("player in sight: ", player_in_sight)
			else:
				player_in_sight = false
				print("player in sight: ", player_in_sight)
