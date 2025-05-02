extends Node2D
@onready var ball: RigidBody2D = $Ball
@onready var label: Label = $CanvasLayer2/Label
@onready var spawnsfx: AudioStreamPlayer2D = $spawnsfx
@onready var bgmusic: AudioStreamPlayer2D = $bgmusic
@onready var lowpass = AudioServer.get_bus_effect(1, 0)
var ball_position
var highest_y : float
var starting_y : float
var score : int
@onready var lava: Node2D = $lava

func _ready() -> void:
	GameManager.camera_2d = $Camera2D
	ball_position = ball.position.y
	highest_y = GameManager.camera_2d.position.y
	starting_y = GameManager.camera_2d.position.y
	spawnsfx.play()
	bgmusic.play()
func _process(delta: float) -> void:
	if (GameManager.camera_2d.position.y < highest_y):
		score = starting_y - highest_y
		highest_y = GameManager.camera_2d.position.y
	#if(Engine.time_scale != 1):
		#bgmusic.bus = "bgmusicslowmo"
	#elif(Engine.time_scale == 1):
		#bgmusic.bus = "bgmusic"
		
	label.text = "chance : " + str(GameManager.chancetothrow) + "\nscore: " + str(score/100 + GameManager.bonus_score) 			

	if (is_instance_valid(ball)):
		if (!ball.died):
			GameManager.camera_2d.position.y = ball.position.y
