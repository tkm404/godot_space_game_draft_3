extends Area2D
class_name CounterMeasure


@export var speed: int = 300

@onready var flare_jet_tail_anim = $FlareJetTailAnim
@onready var flare_time_out_anim = $FlareTimeOutAnim



var direction: Vector2 = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



