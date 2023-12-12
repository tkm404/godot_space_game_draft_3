extends "res://Scripts/enemy_basic.gd"

signal lockedOn
signal inSight

enum STATES {READY, FIRING, RELOADING, LOCKING, LOCKED }

@export var ENEMY_LASER_SCENE: PackedScene

@onready var shoot_timer = $ShootTimer
@onready var enemy_muzzle = $EnemyMuzzle
@onready var hull_damage_anim = $HullDamageAnim
@onready var shield_break_anim = $ShieldBreakAnim
@onready var destroyed_anim = $DestroyedAnim
@onready var body_sprite = $BodySprite
@onready var collision_shape_2d = $CollisionShape2D
@onready var player = get_parent().get_node("Player")
@onready var lock_on_timer = $LockOnTimer
@onready var radar_sight = $RadarSight
@onready var missile_reload_timer = $MissileReloadTimer


var player_in_range
var player_in_sight
var state: STATES = STATES.READY


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
	collision_shape_2d.set_deferred("disabled", true)
	shoot_timer.stop()
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
		change_state(STATES.READY)
		lock_on_timer.stop()
		print("player in range: ", player_in_range)
		print("broke missile lock!")
		


func _on_lock_on_timer_timeout():
	if state == STATES.LOCKING:
		lockedOn.emit()


func _on_locked_on():
	change_state(STATES.LOCKED)
	print("missile lock!")
	missile_reload_timer.start()


func _on_missile_reload_timer_timeout():
	launchMissile()


func change_state(new_state: STATES):
	state = new_state


func SightCheck():
	if player_in_range == true:
		var space_state = get_world_2d().direct_space_state
		var params = PhysicsRayQueryParameters2D.create(global_position, player.global_position, collision_mask, [self, radar_sight])
		params.set_collide_with_areas(true)
		var sight_line = space_state.intersect_ray(params)
		if sight_line:
			if state != STATES.LOCKING && state != STATES.FIRING && state != STATES.LOCKED:
				if sight_line.collider.name == "Player":
					change_state(STATES.LOCKING)
					player_in_sight = true
					print("player in sight: ", player_in_sight)
					print("locking on...")
					lock_on_timer.start()
				else:
					change_state(STATES.READY)
					print(sight_line.collider.name)
					player_in_sight = false
					print("player in sight: ", player_in_sight)


func launchMissile():
	if state == STATES.FIRING:
		return
	change_state(STATES.FIRING)
	if missile_reload_timer.is_stopped():
		print("launching missile!")
	elif !missile_reload_timer.is_stopped():
		print("readying missile")
	
	change_state(STATES.READY)









