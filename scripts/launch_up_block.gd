extends Area2D


# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_body_entered(body: RigidBody2D) -> void:
	if (body.has_method("launch_up")):
		body.launch_up()
		queue_free()
	
