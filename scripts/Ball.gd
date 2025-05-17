extends RigidBody2D
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
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
#var killer
signal kill_ball(killer)
signal activate_mega_shield()
var launching_up_count := 0 

func launch(force: Vector2) -> void:
	sprite_2d.play("front")
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
		throwsfx.pitch_scale = randf_range(0.95, 1.05)
		throwsfx.play()

func launch_up():
		launching_up_count += 1
		sprite_2d.play("front")
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
		launching_up_count -= 1
		if (launching_up_count == 0):
			linear_velocity = Vector2.ZERO
			rocket_particle.emitting = false
			rocket_particle.visible = false
			trail_2d.visible = true
			#await get_tree().create_timer(0.55).timeout
			launching_up = false
		
func ball():
	pass

func activate_shield():
	$CollisionShape2D.scale = Vector2(0.75, 0.75)
	$shieldsfx.play()
	shieldIsActive = true
	shield.visible = true
	shield.shield_sprite.visible = true




func _on_kill_ball(killer: Variant) -> void:
	if (shieldIsActive && !killer.has_method("lava")):
		$breakshieldsfx.play()
		shieldIsActive = false
		if (shield.break_particle.emitting == true):
			shield.break_particle.restart()
		shield.break_particle.emitting = true
		shield.shield_sprite.visible = false
		await get_tree().create_timer(0.2).timeout
		if (is_instance_valid($CollisionShape2D)):
			$CollisionShape2D.scale = Vector2(0.5, 0.5)
	else:
		deadsfx.play()
		died = true
		GameManager.mega_shield_active = false
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
		GameManager.gameLost = true
		queue_free()
		


func _on_activate_mega_shield() -> void:
	mega_shield.visible = true
	shield.visible = false
	GameManager.mega_shield_active = true
	trail_2d.gradient = rainbow_trail_gradient
	mega_shield.mega_shield_particle.emitting = true
	mega_buff_duration.start()
	await mega_buff_duration.timeout
	if (shieldIsActive):
		shield.visible = true
	mega_shield.visible = false
	GameManager.mega_shield_active = false
	mega_shield.mega_shield_particle.emitting = false
	trail_2d.gradient = normal_trail_gradient
