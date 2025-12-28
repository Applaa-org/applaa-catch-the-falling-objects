extends Node2D

@onready var catcher: CharacterBody2D = $Catcher
@onready var score_label: Label = $HUD/ScoreLabel
@onready var lives_label: Label = $HUD/LivesLabel
@onready var falling_objects_container: Node2D = $FallingObjects

var falling_object_scene = preload("res://scenes/FallingObject.tscn")
var spawn_timer: Timer
var difficulty_timer: Timer
var base_speed: float = 100.0
var current_speed: float = 100.0
var spawn_rate: float = 2.0

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_rate
	spawn_timer.timeout.connect(_spawn_object)
	add_child(spawn_timer)
	spawn_timer.start()
	
	difficulty_timer = Timer.new()
	difficulty_timer.wait_time = 10.0
	difficulty_timer.timeout.connect(_increase_difficulty)
	add_child(difficulty_timer)
	difficulty_timer.start()
	
	_update_ui()

func _process(delta):
	_update_ui()
	
	# Check for victory
	if Global.score >= 50:
		get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")
	
	# Check for defeat
	if Global.lives <= 0:
		get_tree().change_scene_to_file("res://scenes/DefeatScreen.tscn")

func _spawn_object():
	var obj = falling_object_scene.instantiate()
	obj.position = Vector2(randf_range(50, 750), -50)
	obj.speed = current_speed
	falling_objects_container.add_child(obj)

func _increase_difficulty():
	current_speed += 20
	spawn_rate = max(0.5, spawn_rate - 0.2)
	spawn_timer.wait_time = spawn_rate

func _update_ui():
	score_label.text = "Score: " + str(Global.score)
	lives_label.text = "Lives: " + str(Global.lives)

func _on_catcher_caught_object():
	Global.add_score(1)

func _on_object_missed():
	Global.lose_life()