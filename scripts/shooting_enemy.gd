extends StaticBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var bullet_cooldown: Timer = $bullet_cooldown
@export var bullets : PackedScene
@onready var shootsfx: AudioStreamPlayer2D = $shootsfx
@onready var sprite_2d: Sprite2D = $Sprite2D


var ball

func _ready() -> void:
	ball = get_parent().get_parent().find_child("Ball")
	
func _physics_process(delta: float) -> void:
	if (GameManager.gameStarted):
		sprite_2d.rotation = ray_cast_2d.target_position.angle() + 1.5
		_aim()
		_check_player_collision()
	
func _aim():
	if (is_instance_valid(ball)):
		if (!ball.died):
			ray_cast_2d.target_position = ray_cast_2d.to_local(ball.global_position)

func _check_player_collision():
	if (is_instance_valid(ball)):
		if (!ball.died):
			var distance = global_position.distance_to(ball.global_position)
			var max_shoot_distance = 2000.0  # Atur sesuai kebutuhan kamu
			if distance > max_shoot_distance:
				# Terlalu jauh, jangan tembak
				bullet_cooldown.stop()
				return
			if (ray_cast_2d.get_collider() == ball and bullet_cooldown.is_stopped()):
				bullet_cooldown.start()
			elif (ray_cast_2d.get_collider() != ball and not bullet_cooldown.is_stopped()):
				bullet_cooldown.stop()


func _on_bullet_cooldown_timeout() -> void:
	_shoot()

func _shoot():
	if (is_instance_valid(ball)):
		if (!ball.died):
			var bullet = bullets.instantiate()
			bullet.direction = (ray_cast_2d.target_position).normalized()
			bullet.position = position + (bullet.direction * Vector2(80, 80)) + sprite_2d.position
			#print(bullet.position)
			get_tree().current_scene.add_child(bullet)
			shootsfx.play()

func block():
	pass
