extends Control

@onready var exit_button: Button = $exit_button
@onready var play_button: Button = $play_button
@export var tween_intensity: float
@export var tween_duration: float

@onready var button_sfx: AudioStreamPlayer2D = $button_sfx
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var score: Label = $score
@export var shake := false
signal game_over
# Called when the node enters the scene tree for the first time.
var shake_fade := 5.0
var rng = RandomNumberGenerator.new()
var shake_strength := 0.0
var original_positon : Vector2
func _ready():
	original_positon = score.position
func apply_shake(strength, shake_duration):
	shake_strength = strength
	shake_fade = shake_duration

		
	
func random_offset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

	
	


func _process(delta: float) -> void:
	if (shake_strength > 0):
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		score.position = random_offset() + original_positon
	else:
		score.position = original_positon
	if (shake):
		shake_strength = 50
		shake_fade = 5.0
		shake = false
	score.text = str(GameManager.score / 320 + GameManager.bonus_score)
	button_hovered(play_button)
	button_hovered(exit_button)
	
func start_tween(object: Object, property: String, final_var: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_var, duration)

func button_hovered(button: Button):
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		start_tween(button, "scale", Vector2.ONE, tween_duration)




func _on_exit_button_pressed() -> void:
	button_sfx.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()


func _on_play_button_pressed() -> void:
	play_button.disabled = true
	button_sfx.play()
	await get_tree().create_timer(0.1).timeout
	SceneTransition.change_scene("res://scenes/main_menu.tscn")


func _on_game_over() -> void:
	play_button.disabled = false
	animation_player.play("game_over")
