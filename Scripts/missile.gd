extends Laser

@export var steer_force = 50.0

@onready var hit_box = $HitBox
@onready var missile_explosion_animation = $Missile_Explosion_Animation
@onready var missilebody = $Missilebody
@onready var missileengine = $Missileengine
@onready var impact_detector = $ImpactDetector




func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _ready():
	missile_explosion_animation.stop()


func _on_area_entered(area):
	if area is Enemy:
		hit_box.set_deferred("disabled", false)
		missilebody.visible = false
		missileengine.visible = false
		speed = 0
		get_tree().create_timer(0.1).connect("timeout", _disable_hitbox)
		missile_explosion_animation.visible = true
		missile_explosion_animation.play("missile_explosion_anim")
		area.take_laser_damage(100)



func _on_timer_timeout():
	hit_box.set_disabled(false)
	missilebody.visible = false
	missileengine.visible = false
	speed = 0
	missile_explosion_animation.visible = true
	missile_explosion_animation.play("missile_explosion_anim")


func _disable_hitbox():
	hit_box.set_disabled(true)


func _on_missile_explosion_animation_animation_finished():
	missile_explosion_animation.queue_free()
	impact_detector.queue_free()
	hit_box.queue_free()
