extends Control

@export var tween_intensity: float
@export var tween_duration: float

@onready var exit: Button = $EXIT
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"

func _process(delta: float) -> void:
	button_hovered(exit)

func button_hovered(button: Button):
	button.pivot_offset = button.size / 2
	if button.is_hovered():
		start_tween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		start_tween(button, "scale", Vector2.ONE, tween_duration)

func start_tween(object: Object, property: String, final_var: Variant, duration: float):
	var tween = create_tween()
	tween.tween_property(object, property, final_var, duration)

func _on_exit_pressed() -> void:
	exit.disabled = true
	$button_sfx.play()
	$"../AnimationPlayer".play("credits",-1, -1.0, true)

func undisable():
	exit.disabled = false

func disable():
	exit.disabled = true
