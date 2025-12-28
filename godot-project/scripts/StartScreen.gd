extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var close_button: Button = $VBoxContainer/CloseButton
@onready var high_score_label: Label = $VBoxContainer/HighScoreLabel
@onready var player_name_input: LineEdit = $VBoxContainer/PlayerNameInput

func _ready():
	start_button.pressed.connect(_on_start_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Initialize high score display
	high_score_label.text = "High Score: 0"
	high_score_label.visible = true
	
	# Load game data
	Global.load_game_data()
	
	# Listen for data loaded (simplified - in practice you'd use a signal or callback)
	await get_tree().create_timer(0.1).timeout
	_update_display()

func _update_display():
	high_score_label.text = "High Score: " + str(Global.high_score)
	if Global.player_name != "":
		player_name_input.text = Global.player_name

func _on_start_pressed():
	Global.player_name = player_name_input.text if player_name_input.text != "" else "Player"
	Global.reset_game()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	Global.save_game_data()
	get_tree().quit()