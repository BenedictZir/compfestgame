extends Node2D
@export var speed = 50
@export var acceleration := 0.3
@onready var deadsfx: AudioStreamPlayer2D = $deadsfx
@onready var deadparticle: CPUParticles2D = $deadparticle
@onready var floatingparticle: CPUParticles2D = $floatingparticle
@onready var floatingparticle_2: CPUParticles2D = $floatingparticle2

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (!GameManager.gameStarted):
		return
	position.y -= speed * delta
	speed = min(speed + acceleration, 1000)
	#print(speed)
	floatingparticle.speed_scale = max(1, speed / 50)
	floatingparticle_2.speed_scale = max(1, speed / 50)

func _on_killzone_body_entered(body: Node2D) -> void:
	if (body.has_method("ball")):
		body.emit_signal("kill_ball", self)

func lava():
	pass
#func _on_destroyzone_body_entered(body: Node2D) -> void:
	#if (!body.has_method("wall")):
		#body.queue_free()
#
#
#func _on_destroyzone_area_entered(area: Area2D) -> void:
	#area.queue_free()
