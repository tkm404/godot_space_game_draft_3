extends Node2D
class_name Game

@export var player: Player
@export var ui: UI


func _ready():
	if !player.collected.is_connected(ui._on_collected):
		player.collected.connect(ui._on_collected)
	if !player.reload_progress.is_connected(ui._on_laser_cooldown):
		player.reload_progress.connect(ui._on_laser_cooldown)
	if !player.reloaded.is_connected(ui.on_laser_available):
		player.reloaded.connect(ui.on_laser_available)
	#
	if !player.used_battery.is_connected(ui._on_player_used_battery):
		player.used_battery.connect(ui._on_player_used_battery)
	if !player.used_repair.is_connected(ui._on_player_used_repair):
		player.used_repair.connect(ui._on_player_used_repair)
	if !player.used_bomb.is_connected(ui._on_player_used_bomb):
		player.used_bomb.connect(ui._on_player_used_bomb)
	if !player.used_flare.is_connected(ui._on_player_used_flare):
		player.used_flare.connect(ui._on_player_used_flare)
