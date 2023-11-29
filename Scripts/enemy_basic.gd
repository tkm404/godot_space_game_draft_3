extends Area2D
class_name Enemy

signal hullDamaged
signal shieldBroke
signal unitDestroyed
signal died()


@export var hp = 100
@export var shields = 50
@export var pickup_scenes: Array[PackedScene] = []
@onready var enemy_basic = $"."

var is_dying: bool = false


func die():
	died.emit()



func take_damage(amount):
	hp -= amount
	hullDamaged.emit()
	if hp <= 0 && !is_dying:
		is_dying = true
		hp = 0
		die()
		unitDestroyed.emit()
	elif hp == 0:
		return



func take_laser_damage(amount):
	var pen = amount - shields
	if shields >= 1 && amount <= shields:
		shields -= amount
	elif shields > 0 && amount > shields:
		shields -= (amount - pen)
		shieldBroke.emit()
		take_damage(pen)
	else:
		take_damage(amount)


func _on_died():
	var pickedPickup = pickup_scenes.pick_random()
	var p = pickedPickup.instantiate()
	if pickup_scenes.find(pickedPickup) == 0:
		print("no drop")
	elif pickup_scenes.find(pickedPickup) != 0:
		print("pickup dropped")
		p.global_position = enemy_basic.global_position
		get_tree().root.call_deferred("add_child", p)
