extends Area2D


var float_amplitude = 10
var float_speed = 4.0
var original_y = 0.0
var time_passed = 0.0

func _ready():
	original_y = position.y

func _process(delta):
	time_passed += delta
	position.y = original_y + sin(time_passed * float_speed) * float_amplitude



func _on_body_entered(body: Node2D) -> void:
	if (body.has_method("activate_shield")):
		body.activate_shield()
		queue_free()
		
