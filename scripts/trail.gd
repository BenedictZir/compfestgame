extends Line2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var queue : Array
@export var MAX_LENGTH : int
var ball
func _ready() -> void:
	ball = get_parent().find_child("Ball")
func _process(delta: float) -> void:
	#if (is_instance_valid(ball)):
		#var pos = ball.position
		#queue.push_front(pos)
	var pos = get_global_mouse_position()
	sprite_2d.position = pos
	queue.push_front(pos)
	if (queue.size() > MAX_LENGTH):
		queue.pop_back()
		
	clear_points()
	
	for point in queue:
		add_point(point)
