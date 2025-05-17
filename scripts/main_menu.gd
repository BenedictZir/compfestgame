extends Control

@onready var menu_music: AudioStreamPlayer2D = $menu_music
@export var tween_intensity: float
@export var tween_duration: float
@onready var start_button: Button = $start_button
@onready var options_button: Button = $options_button
@onready var exit_button: Button = $exit_button
@onready var button_sfx: AudioStreamPlayer2D = $button_sfx
@onready var mainmenulabel: Sprite2D = $mainmenulabel
var float_amplitude = 10
var float_speed = 2
var original_y = 0.0
var original_y_start = 0.0
var original_y_credit = 0.0
var original_y_exit = 0.0

var time_passed = 0.0


func _ready():
	original_y = mainmenulabel.position.y
	original_y_start = start_button.position.y
	original_y_credit = options_button.position.y
	original_y_exit = exit_button.position.y
	
	start_button.disabled = false
	menu_music.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	mainmenulabel.position.y = original_y + sin(time_passed * float_speed) * float_amplitude
	start_button.position.y = original_y_start + sin(time_passed * float_speed) * float_amplitude
	options_button.position.y = original_y_credit + sin(time_passed * float_speed) * float_amplitude
	exit_button.position.y = original_y_exit + sin(time_passed * float_speed) * float_amplitude
	
	
	button_hovered(start_button)
	button_hovered(options_button)
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


func _on_start_button_pressed() -> void:
	button_sfx.play()
	start_button.disabled = true
	await get_tree().create_timer(0.1).timeout
	SceneTransition.change_scene("res://scenes/main.tscn")

func _on_exit_button_pressed() -> void:
	button_sfx.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()


func _on_menu_music_finished() -> void:
	menu_music.play()


func _on_options_button_pressed() -> void:
	pass # Replace with function body.
