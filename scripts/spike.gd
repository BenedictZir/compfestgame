extends StaticBody2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_killzone_body_entered(body: Node2D) -> void:
	if (body.has_method("ball")):
		if (body.launching_up or GameManager.mega_shield_active):
			$AnimationPlayer.play("destroy")

		else:
			body.emit_signal("kill_ball", self)

func spike():
	pass
