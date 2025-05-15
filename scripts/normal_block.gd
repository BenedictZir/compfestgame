extends StaticBody2D




func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body.has_method("ball")):
		if (body.launching_up):
			$AnimationPlayer.play("destroy")
		else:
			$collidingsfx.play()
	
func block():
	pass
