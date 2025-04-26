extends Area2D
signal vector_created(vector)
@export var maximum_length := 200
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var arrow_sprite: Sprite2D = $arrow
@onready var ball: RigidBody2D = $".."
var lowpass = AudioServer.get_bus_effect(1, 0)
var eq = AudioServer.get_bus_effect(1, 1)
var tween: Tween
var touch_down := false
var position_start := Vector2.ZERO
var position_end := Vector2.ZERO
var vector := Vector2.ZERO
var bass = 0
func _ready() -> void:
	arrow_sprite.visible = false
	input_event.connect(_on_input_event)

func _process(_delta: float) -> void:
	if ball.launching_up:
		Engine.time_scale = 1
		arrow_sprite.visible = false
func _input(event: InputEvent) -> void:
	if (ball.launching_up):
		bass = 0
		lowpass.cutoff_hz = 20000
		touch_down = false
		eq.set_band_gain_db(0, bass)
		eq.set_band_gain_db(1, bass)
		return
	if not touch_down:
		bass = 0
		lowpass.cutoff_hz = 20000
		eq.set_band_gain_db(0, bass)
		eq.set_band_gain_db(1, bass)
		return
	if event.is_action_released("ui_touch"):
		lowpass.cutoff_hz = 20000
		bass = 0
		eq.set_band_gain_db(0, bass)
		eq.set_band_gain_db(1, bass)
		var tween = create_tween()
		touch_down = false
		emit_signal("vector_created", vector)
		arrow_sprite.visible = false
		_reset()
	
	if event is InputEventMouseMotion:
		Engine.time_scale = 0.1
		position_end = event.position
		vector = -((position_end - position_start) * Vector2(10, 10)).clamp(Vector2(-maximum_length, -maximum_length), Vector2(maximum_length, maximum_length))
			
		arrow_sprite.visible = true  
		#arrow_sprite.rotation = vector.angle()  # Putar panah sesuai arah vektor
		var target_rotation = vector.angle() 
		arrow_sprite.rotation = lerp_angle(arrow_sprite.rotation, target_rotation, 0.5)
		var direction = vector.normalized()  # Dapatkan arah vektor
		var vector_length = min(vector.length(), maximum_length)
		#print(vector_length)
		arrow_sprite.global_position = sprite_2d.global_position  + (direction * (min(200, vector_length / 10)))
		arrow_sprite.scale.x = min((vector_length / 20000.0), 0.1) 
		#print(arrow_sprite.scale.x)
		lowpass.cutoff_hz = max(2000, lowpass.cutoff_hz - 500)
		bass = min(6, bass + 0.5)
		eq.set_band_gain_db(0, bass)
		eq.set_band_gain_db(1, bass) 
		queue_redraw()

func _on_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("ui_touch"):
		touch_down = true
		position_start = event.position
	
func _reset() -> void:
	position_end = Vector2.ZERO
	position_start = Vector2.ZERO
	vector = Vector2.ZERO
	Engine.time_scale = 1
	queue_redraw()

func vector_creator():
	pass
