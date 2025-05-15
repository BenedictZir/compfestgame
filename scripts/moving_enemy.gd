extends StaticBody2D

@onready var ray_castright: RayCast2D = $RayCastright
@onready var ray_castleft: RayCast2D = $RayCastleft

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var direction = 1

func _physics_process(delta: float) -> void:
	if (ray_castleft.is_colliding()):
		direction = 1
	if (ray_castright.is_colliding()):
		direction = -1
		
	position.x += direction * SPEED * delta
	
func _on_killzone_body_entered(body: Node2D) -> void:
	if (body.has_method("ball")):
		if (body.launching_up or GameManager.mega_shield_active):
			$AnimationPlayer.play("destroy")
		else:
			body.emit_signal("kill_ball", self)
