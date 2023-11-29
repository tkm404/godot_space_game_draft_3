extends Node2D
class_name Weapon

signal reloaded()
signal reload_progress(progress)

enum STATES { READY, FIRING, RELOADING }

@export var LASER_SCENE: PackedScene
@export var LASER_RAPID_SCENE: PackedScene
@export var MISSILE_SCENE: PackedScene

@onready var reload_timer = $ReloadTimer
@onready var muzzle = $Muzzle
@onready var muzzle_2 = $Muzzle2


var state: STATES = STATES.READY


func _process(delta):
	if !reload_timer.is_stopped():
		reload_progress.emit(1 - (reload_timer.time_left / reload_timer.wait_time))

func change_state(new_state: STATES):
	state = new_state
	


func fire():
	if state == STATES.FIRING:
		return
		
	change_state(STATES.FIRING)
	if reload_timer.is_stopped():
		var laser1 = LASER_SCENE.instantiate()
		var laser2 = LASER_SCENE.instantiate()
		laser1.global_position = muzzle.global_position
		laser2.global_position = muzzle_2.global_position
		get_tree().root.add_child(laser1)
		get_tree().root.add_child(laser2)
	elif !reload_timer.is_stopped():
		var laser_rapid1 = LASER_RAPID_SCENE.instantiate()
		var laser_rapid2 = LASER_RAPID_SCENE.instantiate()
		laser_rapid1.global_position = muzzle.global_position
		laser_rapid2.global_position = muzzle_2.global_position
		get_tree().root.add_child(laser_rapid1)
		get_tree().root.add_child(laser_rapid2)
	
	change_state(STATES.RELOADING)
	reload_timer.start()


func _on_reload_timer_timeout():
	change_state(STATES.READY)
	reloaded.emit()


func launch():
	var missile = MISSILE_SCENE.instantiate()
	missile.global_position = muzzle.global_position
	get_tree().root.add_child(missile)
