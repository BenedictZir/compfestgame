extends RigidBody2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var trail_2d: Line2D = $Trail2D
@onready var rocket_particle: CPUParticles2D = $rocket_particle
@onready var vector_creator: Area2D = $"../VectorCreator"
@onready var throwsfx: AudioStreamPlayer2D = $throwsfx
@onready var rocketsfx: AudioStreamPlayer2D = $rocketsfx
@onready var nochancesfx: AudioStreamPlayer2D = $nochancesfx
@onready var collidingsfx: AudioStreamPlayer2D = $collidingsfx
@onready var deadparticle: CPUParticles2D = $deadparticle
@onready var deadsfx: AudioStreamPlayer2D = $deadsfx
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D
@onready var shield: Node2D = $shield
@onready var mega_shield: Node2D = $mega_shield
@onready var mega_buff_duration: Timer = $mega_buff_duration
@onready var launchparticle: CPUParticles2D = $launchparticle

@export var normal_trail_gradient: Gradient
@export var rainbow_trail_gradient: Gradient
var launching_up := false
var died = false
var shieldIsActive = false
var killer
signal kill_ball(killer)
signal activate_mega_shield()

func launch(force: Vector2) -> void:
	if (launching_up):
		return
	if (GameManager.chancetothrow < 1 and !GameManager.mega_shield_active):
		nochancesfx.play()
		var tween = create_tween()
		tween.tween_property(sprite_2d, "modulate", Color.RED, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(sprite_2d, "modulate", Color.WHITE, 0.3)

		return
	if (abs(force.x) > 300 or abs(force.y)  > 300):
		if (!GameManager.gameStarted):
			GameManager.gameStarted = true
		if (!GameManager.mega_shield_active):
			GameManager.chancetothrow -= 1
		linear_velocity = Vector2.ZERO
		apply_impulse(force * 1.2)
		if (launchparticle.emitting == true):
			launchparticle.restart()
		launchparticle.emitting = true
		throwsfx.play()

func launch_up():
		sprite_2d.rotation = rad_to_deg(0)
		launching_up = true
		linear_velocity = Vector2.ZERO
		rocket_particle.visible = true
		rocket_particle.emitting = true
		trail_2d.visible = false
		var target_y = global_position.y - 6000
		rocketsfx.play()
		var tween = create_tween()
		tween.tween_property(self, "position:y", target_y, 2.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await tween.finished
		linear_velocity = Vector2.ZERO
		rocket_particle.emitting = false
		rocket_particle.visible = false
		trail_2d.visible = true
		#await get_tree().create_timer(0.55).timeout
		launching_up = false
		
func ball():
	pass

func activate_shield():
	shieldIsActive = true
	shield.visible = true
	shield.shield_sprite.visible = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.has_method("block")):
		if (not launching_up):
			pass
			#GameManager.camera_2d.apply_shake(2, 10)
		collidingsfx.play()
	if (body.has_method("_aim")):
		body.queue_free()


func _on_kill_ball(killer: Variant) -> void:
	if (launching_up or GameManager.mega_shield_active) and !killer.has_method("lava"):
			collidingsfx.play()
			killer.queue_free()
	elif (shieldIsActive && !killer.has_method("lava")):
		shieldIsActive = false
		shield.break_particle.emitting = true
		shield.shield_sprite.visible = false
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
		trail_2d.visible = false
		GameManager.camera_2d.apply_shake(50, 5.0)
		await get_tree().create_timer(deadparticle.lifetime).timeout
		queue_free()
		


func _on_activate_mega_shield() -> void:
	mega_shield.visible = true
	GameManager.mega_shield_active = true
	trail_2d.gradient = rainbow_trail_gradient
	mega_shield.mega_shield_particle.emitting = true
	mega_buff_duration.start()
	await mega_buff_duration.timeout
	mega_shield.visible = false
	GameManager.mega_shield_active = false
	mega_shield.mega_shield_particle.emitting = false
	trail_2d.gradient = normal_trail_gradient
