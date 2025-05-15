extends Node2D
@onready var ball: RigidBody2D = $Ball
@onready var label: Label = $CanvasLayer2/score_chance
@onready var spawnsfx: AudioStreamPlayer2D = $spawnsfx
@onready var bgmusic: AudioStreamPlayer2D = $bgmusic
@onready var lowpass = AudioServer.get_bus_effect(1, 0)
@onready var vector_creator: Area2D = $VectorCreator
@onready var mega_buff_indicator: Sprite2D = $CanvasLayer2/mega_buff_indicator
@onready var mega_buff_indicator_2: Sprite2D = $CanvasLayer2/mega_buff_indicator2
@onready var mega_buff_indicator_3: Sprite2D = $CanvasLayer2/mega_buff_indicator3
@onready var mega_buff_label: Label = $CanvasLayer2/mega_buff
@onready var rainbow_inf: Sprite2D = $CanvasLayer2/rainbow_inf
@onready var game_over: Control = $CanvasLayer2/game_over
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var spawn_container: Node2D
@export var bonus_score_scene: PackedScene
@export var launch_up_block_scene: PackedScene
@export var mega_shield_pickup_scene: PackedScene
@export var minus_chance_scene: PackedScene
@export var plus_chance_scene: PackedScene
@export var shield_pickup_scene: PackedScene
@export var spike_scene: PackedScene
@export var spike2_scene: PackedScene
@export var spike3_scene: PackedScene
@export var two_block_scene: PackedScene
@export var obstacle1_scene :PackedScene
@export var obstacle2_scene :PackedScene
@export var obstacle3_scene :PackedScene
@export var l_block_scene: PackedScene
@export var block_scene: PackedScene
@export var obstacle4_scene: PackedScene
@export var moving_enemy_scene: PackedScene
@export var shooting_enemy_scene: PackedScene
@export var obstacle5_scene: PackedScene
@export var obstacle6_scene: PackedScene
@export var obstacle7_scene: PackedScene
@export var obstacle8_scene: PackedScene
@export var obstacle9_scene: PackedScene
@export var obstacle10_scene: PackedScene
@export var obstacle11_scene: PackedScene
@export var starting_platform: PackedScene 
#582 234
var last_picked
var spike_types = []

var obstacle_types = []
var enemy_types = []
var debuff_types = []
var buff_types = []
var mega_buff_types = []
const SPAWN_INTERVAL_Y := 1000  
const OBJECTS_PER_BATCH := 8  
var last_generated_y := -2000
var gameOverShown := false
var ball_y_position
var highest_y : float
var starting_y : float
@onready var lava: Node2D = $lava

func _ready() -> void:
	
	#print(obj.position)
	GameManager.chancetothrow = 10
	GameManager.bonus_score = 0
	GameManager.score = 0
	GameManager.mega_shield_count = 0
	gameOverShown = false
	GameManager.gameLost = false
	spike_types = [
		spike2_scene,
		spike3_scene,
		spike_scene
		#block_scene,
		#two_block_scene
	]

	obstacle_types = [
		obstacle1_scene,
		obstacle2_scene,
		obstacle3_scene,
		obstacle4_scene,
		obstacle5_scene,
		block_scene,
		two_block_scene,
		obstacle6_scene,
		obstacle7_scene,
		obstacle8_scene,
		obstacle9_scene,
		obstacle10_scene,
		obstacle11_scene
	]
	enemy_types = [
		moving_enemy_scene,
		shooting_enemy_scene
	]

	buff_types = [
		bonus_score_scene,
		bonus_score_scene,
		launch_up_block_scene,
		plus_chance_scene,
		plus_chance_scene,
		plus_chance_scene,
		shield_pickup_scene
	]
	debuff_types = [
		block_scene,
		minus_chance_scene
	]
	mega_buff_types = [mega_shield_pickup_scene]
	vector_creator.position = ball.position
	GameManager.camera_2d = $Camera2D
	ball_y_position = ball.position.y
	highest_y = GameManager.camera_2d.position.y
	starting_y = GameManager.camera_2d.position.y
	spawnsfx.play()
	bgmusic.play()
func _process(delta: float) -> void:
	if ($Timer.is_stopped() and mega_buff_label.visible):
		$Timer.start()
	if GameManager.gameLost and !gameOverShown:
		GameManager.gameStarted = false
		gameOverShown = true
		label.visible = false
		animation_player.play("game_over")
		await animation_player.animation_finished
		game_over.emit_signal("game_over")
	if (is_instance_valid(ball)):
		if (!ball.died):
			ball_y_position = ball.position.y
	if(ball_y_position - 4000 < last_generated_y - SPAWN_INTERVAL_Y):
		generate_objects_in_area()
	if (is_instance_valid(ball)):
		if (!ball.died):
			vector_creator.position = ball.position
	if (GameManager.camera_2d.position.y < highest_y):
		GameManager.score = starting_y - highest_y
		highest_y = GameManager.camera_2d.position.y
	if (GameManager.mega_shield_count >= 1):
		mega_buff_indicator.self_modulate.a8 = 255
	if (GameManager.mega_shield_count >= 2):
		mega_buff_indicator_2.self_modulate.a8 = 255
	if (GameManager.mega_shield_count >= 3):
		mega_buff_indicator_3.self_modulate.a8 = 255
		mega_buff_label.visible = true




	if (!GameManager.mega_shield_active):
		rainbow_inf.visible = false
		label.text = "fuel : " + str(GameManager.chancetothrow) + "\nscore : " + str(GameManager.score/300 + GameManager.bonus_score) 			
	else:
		rainbow_inf.visible = true
		label.text = "fuel : " + "\nscore : " + str(GameManager.score/300 + GameManager.bonus_score) 			
	if (is_instance_valid(ball)):
		if (!ball.died):
			GameManager.camera_2d.position.y = ball.position.y

func _input(event: InputEvent) -> void:
	if event.is_action("activate") and GameManager.mega_shield_count >= 3:
		if (is_instance_valid(ball)):
			if (!ball.died):
				GameManager.mega_shield_count = 0
				mega_buff_label.visible = false
				mega_buff_indicator_3.self_modulate.a8 = 100
				mega_buff_indicator_2.self_modulate.a8 = 100
				mega_buff_indicator.self_modulate.a8 = 100
				ball.emit_signal("activate_mega_shield")

func generate_objects_in_area():
		var scene: PackedScene
		var scene2: PackedScene
		var chance
		var x1 = 0
		var x2 = 0
		while(true):
			chance = randi() % 100
			if chance < 10:
				if (last_picked == enemy_types):
					continue
				scene = enemy_types.pick_random()
				last_picked = enemy_types
				break
			elif chance < 15:
				if (last_picked == debuff_types):
					continue
				scene = debuff_types.pick_random()
				last_picked = debuff_types
				break
			elif chance < 55:
				if (last_picked == buff_types):
					continue
				scene = buff_types.pick_random()
				last_picked = buff_types
				break
			elif chance < 75:
				if (last_picked == obstacle_types):
					continue
				scene = obstacle_types.pick_random()
				last_picked = obstacle_types
				break
			elif chance < 90:
				if (last_picked == spike_types):
					continue
				scene = spike_types.pick_random()
				last_picked = spike_types
				break
			elif chance < 92:
				if (last_picked == mega_buff_types):
					continue
				scene = mega_shield_pickup_scene
				last_picked = mega_buff_types
				break
			break
	
		while(true):
			if (last_picked == obstacle_types):
				break
			chance = randi() % 100
			if chance < 3 and last_picked != enemy_types:
				scene2 = enemy_types.pick_random()
				last_picked = enemy_types
				break
			elif chance < 8 and last_picked != debuff_types:
				scene2 = debuff_types.pick_random()
				last_picked = debuff_types
				break
			elif chance < 15 and last_picked != buff_types:
				scene2 = buff_types.pick_random()
				last_picked = buff_types
				break
			elif chance < 20 and last_picked != spike_types:
				scene2 = spike_types.pick_random()
				last_picked = spike_types
				break
			elif chance < 21 and last_picked != mega_buff_types:
				scene2 = mega_shield_pickup_scene
				last_picked = mega_buff_types
				break
			break

		var height = 650

		if (scene != null):
			var obj = scene.instantiate()

			x1 = randf_range(-121, 1018)
			if (last_picked == obstacle_types):
				x1 = -121
			var y = last_generated_y
			if (last_picked == spike_types):
				y += 38
			if (scene == spike2_scene and x1 > 960):
				x1 -= 50
			obj.global_position = Vector2(x1, y)


			spawn_container.add_child(obj)
		if (scene2 != null):
			var obj = scene2.instantiate()

			x2 = randf_range(-121, 1018)
			var try = 0
			while(abs(x2 - x1) < 400 and try <= 100):
				try += 1
				x2 = randf_range(-121, 1018)
			if (try >= 100):
				x2 = x1 + 300
				if (x2 > 1000):
					x2 = x1 - 300
			var y = last_generated_y
			if (scene == spike2_scene and x2 > 960):
				x2 -= 50
			if (last_picked == spike_types):
				y += 38
			obj.global_position = Vector2(x2, y)
			spawn_container.add_child(obj)
		last_generated_y -= height


func _on_timer_timeout() -> void:
	var r = randi_range(130, 240)
	var g = randi_range(130, 240)
	var b = randi_range(130, 240)
	var color = Color8(r, g, b, 255)
	mega_buff_label.add_theme_color_override("font_color", color)
