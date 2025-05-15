extends Node2D

@export var speed_range := Vector2(50, 150)
@export var area_margin := 100

var velocity := Vector2.ZERO
var screen_size := Vector2.ZERO

@onready var anim_sprite: AnimatedSprite2D = $"."


func _ready():
	screen_size = get_viewport_rect().size
	randomize()
	reset_character()

func _process(delta):
	position += velocity * delta
	update_animation()

	if is_out_of_screen():
		reset_character()

func is_out_of_screen() -> bool:
	return position.x < -area_margin or position.x > screen_size.x + area_margin \
		or position.y < -area_margin or position.y > screen_size.y + area_margin

func reset_character():
	# Pilih posisi spawn acak di luar layar
	var sides = [ "top", "bottom", "left", "right" ]
	var side = sides[randi() % sides.size()]
	match side:
		"top":
			position = Vector2(randf_range(0, screen_size.x), -area_margin)
		"bottom":
			position = Vector2(randf_range(0, screen_size.x), screen_size.y + area_margin)
		"left":
			position = Vector2(-area_margin, randf_range(0, screen_size.y))
		"right":
			position = Vector2(screen_size.x + area_margin, randf_range(0, screen_size.y))

	var target = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
	velocity = (target - position).normalized() * randf_range(speed_range.x, speed_range.y)

func update_animation():
	var angle = velocity.angle()
	var dir := ""

	# Konversi sudut ke arah animasi
	if angle > -PI/8 and angle <= PI/8:
		dir = "right"
	elif angle > PI/8 and angle <= 3*PI/8:
		dir = "down_right"
	elif angle > 3*PI/8 and angle <= 5*PI/8:
		dir = "down_front"
	elif angle > 5*PI/8 and angle <= 7*PI/8:
		dir = "down_left"
	elif angle <= -7*PI/8 or angle > 7*PI/8:
		dir = "left"
	elif angle > -7*PI/8 and angle <= -5*PI/8:
		dir = "up_left"
	elif angle > -5*PI/8 and angle <= -3*PI/8:
		dir = "up_front"
	elif angle > -3*PI/8 and angle <= -PI/8:
		dir = "up_right"

	# Ganti animasi kalau berbeda
	if anim_sprite.animation != dir:
		anim_sprite.play(dir)
