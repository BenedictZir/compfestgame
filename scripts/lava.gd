extends Node2D
@export var speed := 100
@export var acceleration := 40
@onready var deadsfx: AudioStreamPlayer2D = $deadsfx
@onready var deadparticle: CPUParticles2D = $deadparticle
@onready var floatingparticle: CPUParticles2D = $floatingparticle
@onready var floatingparticle_2: CPUParticles2D = $floatingparticle2
@onready var camera_2d: Camera2D = $"../Camera2D"

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y -= speed * delta
	speed += acceleration * delta
	floatingparticle.speed_scale = max(1, speed / 50)
	floatingparticle_2.speed_scale = max(1, speed / 50)

func _on_killzone_body_entered(body: Node2D) -> void:
	if (body.has_method("ball")):
		body.emit_signal("kill_ball", self)
		if (body.died):
			camera_2d.apply_shake(50, 5.0)


func lava():
	pass
#func _on_destroyzone_body_entered(body: Node2D) -> void:
	#if (!body.has_method("wall")):
		#body.queue_free()
#
#
#func _on_destroyzone_area_entered(area: Area2D) -> void:
	#area.queue_free()
