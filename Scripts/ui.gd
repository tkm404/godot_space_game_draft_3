extends CanvasLayer
class_name UI

#Displays Pickups: repair kits, shield batteries, missiles, mines, countermeasures
#Displays Targets: asteroids, key enemies, key pickups
#Displays Score: works as a sort of timer to complete missions, flexible to collect x number of items, or represent a certain score, or represent a timer countdown
#Displays weapon cooldowns

signal repair_empty()
signal battery_empty()
signal bomb_empty()
signal flare_empty()
signal missile_amount_update(amount)
signal flares_amount_update(amount)
signal repair_amount_update(amount)
signal battery_amount_update(amount)



@onready var score_label = %Score
@onready var hull_status = %HullStatus
@onready var laser_cooldown = %LaserCooldown
@onready var shield_cooldown = %ShieldCooldown
@onready var bomb_amount = %BombAmount
@onready var flare_amount = %FlareAmount
@onready var battery_amount = %BatteryAmount
@onready var repair_amount = %RepairAmount




var score = 0:
	set(new_score):
		score = new_score
		_update_score_label()
		

var bomb = 0:
	set(new_bomb):
		bomb = new_bomb
		_update_bomb_amount()
		missile_amount_update.emit(bomb)


var flare = 0:
	set(new_flare):
		flare = new_flare
		_update_flare_amount()
		flares_amount_update.emit(flare)


var battery = 0:
	set(new_battery):
		battery = new_battery
		_update_battery_amount()
		battery_amount_update.emit(battery)


var repair = 0:
	set(new_repair):
		repair = new_repair
		_update_repair_amount()
		repair_amount_update.emit(repair)


func _ready():
	_update_score_label()
	_update_bomb_amount()
	_update_flare_amount()
	_update_battery_amount()
	_update_repair_amount()
	shield_cooldown.max_value = get_node("../Player").shields
	shield_cooldown.value = get_node("../Player").shields


func _update_score_label() -> void:
	score_label.text = "Score: " + str(score)

func _update_bomb_amount():
	bomb_amount.text = str(bomb)


func _update_flare_amount() -> void:
	flare_amount.text = str(flare)


func _update_battery_amount() -> void:
	battery_amount.text = str(battery)


func _update_repair_amount() -> void:
	repair_amount.text = str(repair)


func _on_collected(pickup) -> void:
	if pickup:
		print(pickup)
		if pickup.is_in_group("Bombs"):
			bomb += 1
		elif pickup.is_in_group("Flares"):
			flare += 1
		elif pickup.is_in_group("Batteries"):
			battery += 1
		elif pickup.is_in_group("Repairs"):
			repair += 1


func _on_laser_cooldown(progress) -> void:
	laser_cooldown.value = progress


func on_laser_available() -> void:
	laser_cooldown.value = 1


func _on_shield_cooldown(progress) -> void:
	shield_cooldown.value = progress


func _on_hull_status(progress) -> void:
	hull_status.value = progress


func _on_player_shield_changed(amount):
	shield_cooldown.value -= amount


func _on_player_hull_changed(amount):
	hull_status.value -= amount


func _on_player_used_battery():
	if battery > 0:
		battery -= 1
		battery_amount_update.emit(battery)
	elif battery <= 0:
		battery_amount_update.emit(battery)
		print("out of batteries!")
		battery = 0


func _on_player_used_repair():
	if repair > 0:
		repair -= 1
		repair_amount_update.emit(repair)
	elif repair <= 0:
		repair_amount_update.emit(repair)
		print("out of repair bots!")
		repair = 0


func _on_player_used_bomb():
	if bomb > 0:
		bomb -= 1
		missile_amount_update.emit(bomb)
	elif bomb <= 0:
		missile_amount_update.emit(bomb)
		print("out of bombs!")
		bomb = 0


func _on_player_used_flare():
	if flare > 0:
		flare -= 1
		flares_amount_update.emit(flare)
	elif flare <= 0:
		flares_amount_update.emit(flare)
		print("out of flares!")
		flare = 0
