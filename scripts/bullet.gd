extends Area2D


var direction: Vector2 = Vector2.RIGHT
var speed: float = 500
@onready var break_particle: CPUParticles2D = $break_particle
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	sprite_2d.rotation = direction.angle() + 1.5
	position += direction * speed * delta
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if (body.has_method("ball")):
		if (!body.launching_up and !GameManager.mega_shield_active):
			body.emit_signal("kill_ball", self)
	elif (body.has_method("_shoot")):
		return
	break_particle.emitting = true
	collision_shape_2d.queue_free()
	sprite_2d.visible = false


func _on_area_entered(area: Area2D) -> void:
	break_particle.emitting = true
	collision_shape_2d.queue_free()
	sprite_2d.visible = false
