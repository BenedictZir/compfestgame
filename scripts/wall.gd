extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func wall():
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if (is_instance_valid(body)):
		if (body.has_method("ball")):
			if !body.launching_up:	
				$collidingsfx.pitch_scale = randf_range(1.2, 1.4)
				$collidingsfx.play()
