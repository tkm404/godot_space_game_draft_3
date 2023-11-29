extends Area2D


@export var speed: int = 300

@onready var flare_jet_tail_anim = $FlareJetTailAnim
@onready var flare_time_out_anim = $FlareTimeOutAnim



var direction: Vector2 = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	flare_jet_tail_anim.play('default')



func _physics_process(delta):
	position -= transform.y * speed * delta


func _on_timer_timeout():
	flare_time_out_anim.visible = true
	flare_time_out_anim.play("default")
	flare_jet_tail_anim.stop()
	flare_jet_tail_anim.visible = false


func _on_flare_time_out_anim_animation_finished():
	flare_time_out_anim.stop()
	flare_time_out_anim.visible = false
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
