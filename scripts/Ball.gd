extends RigidBody2D
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var rocket_particle: CPUParticles2D = $rocket_particle
@onready var vector_creator: Area2D = $VectorCreator
@onready var throwsfx: AudioStreamPlayer2D = $throwsfx
@onready var rocketsfx: AudioStreamPlayer2D = $rocketsfx
@onready var nochancesfx: AudioStreamPlayer2D = $nochancesfx
@onready var collidingsfx: AudioStreamPlayer2D = $collidingsfx
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var deadparticle: CPUParticles2D = $deadparticle
@onready var deadsfx: AudioStreamPlayer2D = $deadsfx
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D

var launching_up := false
var died = false
var shieldIsActive = false
var killer
signal kill_ball(killer)

func launch(force: Vector2) -> void:
	if (launching_up):
		return
	if (GameManager.chancetothrow < 1):
		nochancesfx.play()
		var tween = create_tween()
		tween.tween_property(sprite_2d, "modulate", Color.RED, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.3)

		return
	if (abs(force.x) > 300 or abs(force.y)  > 300):
		GameManager.chancetothrow -= 1
		linear_velocity = Vector2.ZERO
		apply_impulse(force * 1.2)
		throwsfx.play()

func launch_up():
		launching_up = true
		linear_velocity = Vector2.ZERO
		rocket_particle.emitting = true
		
		var target_y = global_position.y - 5000
		rocketsfx.play()
		var tween = create_tween()
		tween.tween_property(self, "position:y", target_y, 2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await tween.finished
		rocket_particle.emitting = false
		launching_up = false
		
func ball():
	pass

func activate_shield():
	shieldIsActive = true
	#shield.visible = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.has_method("block") or body.has_method("wall")):
		if (not launching_up):
			camera_2d.apply_shake(2, 10)
		collidingsfx.play()


func _on_kill_ball(killer: Variant) -> void:
	if (launching_up):
		pass
		if (killer.has_method("block")):
			killer.queue_free()
	elif (shieldIsActive):
		shieldIsActive = false
		#shield.visible = false
	else:
		deadsfx.play()
		died = true
		deadparticle.global_position = global_position
		Engine.time_scale = 1
		sprite_2d.visible = false
		
		deadparticle.emitting = true
		area_2d.queue_free()
		collision_shape_2d.queue_free()
		vector_creator.queue_free()
		await get_tree().create_timer(deadparticle.lifetime).timeout
		queue_free()
