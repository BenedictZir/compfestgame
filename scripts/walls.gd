extends Node2D
var wall_x_coordinate := [-153, 1046]
@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var walls: Node2D = $"."

var wall_scene = preload("res://scenes/wall.tscn")
@export var spawn_distance := 230
@onready var wall: StaticBody2D = $wall
@onready var lava: Node2D = $"../lava"

var last_y = 240
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(20):
		spawn_walls()


func _process(delta: float) -> void:
	if (camera_2d.position.y - last_y < spawn_distance + 2000):
		spawn_walls()
	for wall in get_children():
		if wall.position.y > lava.position.y + 4500:
			wall.queue_free()
	
func spawn_walls():
	var left_wall = wall_scene.instantiate()
	var right_wall = wall_scene.instantiate()
	last_y -= spawn_distance
	left_wall.position = Vector2(wall_x_coordinate[0], last_y)
	right_wall.position = Vector2(wall_x_coordinate[1], last_y)
	add_child(left_wall)
	add_child(right_wall)

	
