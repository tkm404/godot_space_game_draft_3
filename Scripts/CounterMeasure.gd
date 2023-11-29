extends Node2D
class_name CounterMeasure


@export var FLARE_SCENE: PackedScene

@onready var flare_launcher = $FlareLauncher



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func launch():
	var flare = FLARE_SCENE.instantiate()
	flare.rotation_degrees = 135
	flare.global_position = flare_launcher.global_position
	get_tree().root.add_child(flare)
