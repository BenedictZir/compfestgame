extends Control
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var line_edit: LineEdit = $codebox/LineEdit
@onready var codebox: Sprite2D = $codebox
@onready var exit: Button = $EXIT
@onready var label: Label = $Label

@onready var menu_music: AudioStreamPlayer2D = $menu_music
@export var tween_intensity: float
@export var tween_duration: float
@onready var start_button: Button = $start_button
@onready var options_button: Button = $options_button
@onready var button_sfx: AudioStreamPlayer2D = $button_sfx
@onready var mainmenulabel: Sprite2D = $mainmenulabel
var float_amplitude = 10
var float_speed = 2
var original_y = 0.0
var original_y_start = 0.0
var original_y_credit = 0.0
var original_y_exit = 0.0
var original_y_codebox = 0.0
var original_y_label = 0.0
var time_passed = 0.0


func _ready():
	GlobalGameCodeVerifier.request_failed.connect(request_failed)
	GlobalGameCodeVerifier.game_code_succeed.connect(game_code_succeed)
	GlobalGameCodeVerifier.game_code_failed.connect(game_code_failed)
	original_y = mainmenulabel.position.y
	original_y_start = start_button.position.y
	original_y_credit = options_button.position.y
	original_y_exit = exit.position.y
	original_y_codebox = codebox.position.y
	original_y_label = label.position.y
	
	start_button.disabled = false
	menu_music.play()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_passed += delta
	mainmenulabel.position.y = original_y + sin(time_passed * float_speed) * float_amplitude
	start_button.position.y = original_y_start + sin(time_passed * float_speed) * float_amplitude
	options_button.position.y = original_y_credit + sin(time_passed * float_speed) * float_amplitude
	codebox.position.y = original_y_codebox + sin(time_passed * float_speed) * float_amplitude
	exit.position.y = original_y_exit + sin(time_passed * float_speed) * float_amplitude
	label.position.y = original_y_label + sin(time_passed * float_speed) * float_amplitude
	
	
	
	button_hovered(start_button)
	button_hovered(options_button)
	button_hovered($EXIT)
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
	$AnimationPlayer.play("play")
	await animation_player.animation_finished
	line_edit.editable = true
	$EXIT.disabled = false
	
	#SceneTransition.change_scene("res://scenes/main.tscn")



func _on_menu_music_finished() -> void:
	menu_music.play()


func _on_options_button_pressed() -> void:
	$options_button.disabled = true
	button_sfx.play()
	$AnimationPlayer.play("credits")
func request_failed(error_message: String):
	label.visible = true
	$Label.text = "TOKEN NOT FOUND!"

func game_code_succeed(error_message: String):
	$correcttokensfx.play()
	label.visible = false
	await get_tree().create_timer(0.1).timeout
	SceneTransition.change_scene("res://scenes/main.tscn")
	
	

func game_code_failed(error_message: String):
	label.visible = true
	$Label.text = "TOKEN NOT FOUND!"
	
	




func _on_line_edit_text_submitted(new_text: String) -> void:
	#SceneTransition.change_scene("res://scenes/main.tscn")
	#print(new_text)
	GlobalGameCodeVerifier.verify_game_code(new_text)
	
	


func _on_exit_pressed() -> void:
	button_sfx.play()
	line_edit.editable = false
	label.visible = false
	$EXIT.disabled = true
	$"AnimationPlayer".play("play",-1, -1.0, true)
	await animation_player.animation_finished
	start_button.disabled = false
	options_button.disabled = false
