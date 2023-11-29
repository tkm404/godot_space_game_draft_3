extends CharacterBody2D
class_name Player

signal collected(pickup)
signal reloaded()
signal reload_progress(progress)
signal died()
signal shield_changed(amount)
signal hull_changed(amount)
signal used_bomb()
signal used_flare()
signal used_repair()
signal used_battery()

@export var speed: int = 300
@export var shields: int = 50
@export var hp: int = 100
@export var current_missiles: int = 0
@export var current_flares: int = 0
@export var current_repair: int = 0
@export var current_battery: int = 0
@export var weapon: Weapon
@onready var engine = $Engine


@onready var shield_break = $ShieldBreak
@onready var hull_damage = $HullDamage
@onready var player_exploded = $PlayerExploded
@onready var body_sprite = $BodySprite
@onready var shield_damaged_anim = $ShieldDamagedAnim




var current_shields
var current_hp
var max_hp = 100
var min_hp = 0
var max_shields = 50
var min_shields = 0

func _ready():
	weapon.reloaded.connect(func (): reloaded.emit())
	weapon.reload_progress.connect(func(progress): reload_progress.emit(progress))


func _physics_process(delta):
	var direction = Vector2(Input.get_axis("left", "right"),
	Input.get_axis("up", "down"))
	velocity = direction * speed
	move_and_slide()
	
	global_position = global_position.clamp(Vector2.ZERO, get_viewport_rect().size)


func collect(pickup):
	collected.emit(pickup)


func _input(event):
	if event.is_action_pressed("shoot"):
		#space
		weapon.fire()
	if event.is_action_pressed("use_bomb"):
		#c key
		if current_missiles >= 1:
			used_bomb.emit()
			print("dropped bomb!")
			weapon.launch()
		else:
			print("out of bombs!")
	if event.is_action_pressed("use_flare"):
		#v key
		if current_flares >= 1:
			used_flare.emit()
			print("punching flares!")
		else:
			print("out of flares!")
	if event.is_action_pressed("use_repair"):
		#r key
		if current_repair >= 1:
			var full_health = max_hp - hp
			if hp > 76 && hp < max_hp:
				used_repair.emit()
				hp += full_health
				hull_changed.emit(-full_health)
			elif hp <= 75:
				used_repair.emit()
				hp += 25
				hull_changed.emit(-25)
			elif hp == max_hp:
				print("already at full health!")
		else:
			print("out of repair bots!")
	if event.is_action_pressed("use_battery"):
		#f key
		if current_battery >= 1:
			var full_shields = max_shields - shields
			if shields > 26 && shields < max_shields:
				used_battery.emit()
				shields += full_shields
				shield_changed.emit(-full_shields)
			elif shields <= 25:
				used_battery.emit()
				shields += 25
				shield_changed.emit(-25)
			elif shields == max_shields:
				print("already at full shields!")
		else:
			print("out of shield batteries!")


func die():
	died.emit()




func take_damage(amount):
	hp -= amount
	hull_changed.emit(amount)
	hull_damage.visible = true
	hull_damage.play("hull_damage_animation")
	if hp <= 0:
		hp = 0
		speed = 0
		engine.visible = false
		weapon.visible = false
		body_sprite.visible = false
		player_exploded.visible = true
		player_exploded.play("default")
		die()


func take_laser_damage(amount):
	var pen = amount - shields
	if shields >= 1 && amount <= shields:
		shields -= amount
		shield_damaged_anim.visible = true
		shield_damaged_anim.play("default")
		shield_changed.emit(amount)
	elif shields > 0 && amount > shields:
		shields -= (amount - pen)
		shield_changed.emit(amount - pen)
		shield_break.visible = true
		shield_break.play("default")
		take_damage(pen)
	else:
		take_damage(amount)



func _on_ui_bomb_empty():
	current_missiles = 0


func _on_ui_missile_amount_update(amount):
	current_missiles = amount


func _on_ui_repair_amount_update(amount):
	current_repair = amount


func _on_ui_flares_amount_update(amount):
	current_flares = amount


func _on_ui_battery_amount_update(amount):
	current_battery = amount


func _on_shield_break_animation_finished():
	shield_break.stop()
	shield_break.visible = false


func _on_hull_damage_animation_finished():
	hull_damage.stop()
	hull_damage.visible = false


func _on_player_exploded_animation_finished():
	player_exploded.stop()
	player_exploded.visible = false
	queue_free()


func _on_shield_damaged_anim_animation_finished():
	shield_damaged_anim.stop()
	shield_damaged_anim.visible = false
