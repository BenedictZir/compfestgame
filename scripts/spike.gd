extends StaticBody2D
@onready var deadsfx: AudioStreamPlayer2D = $deadsfx
@onready var deadparticle: CPUParticles2D = $deadparticle
@onready var camera_2d: Camera2D = $"../Camera2D"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_killzone_body_entered(body: Node2D) -> void:
	if (body.has_method("ball")):
		body.emit_signal("kill_ball", self)
		if (body.died):
			camera_2d.apply_shake(50, 5.0)
func block():
	pass
