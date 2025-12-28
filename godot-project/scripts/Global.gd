extends Node

var score: int = 0
var lives: int = 3
var high_score: int = 0
var player_name: String = ""

func _ready():
	load_game_data()

func add_score(points: int):
	score += points
	if score > high_score:
		high_score = score

func lose_life():
	lives -= 1

func reset_game():
	score = 0
	lives = 3

func save_game_data():
	var data = {
		"highScore": high_score,
		"lastPlayerName": player_name,
		"scores": [{"playerName": player_name, "score": score, "timestamp": Time.get_datetime_string_from_system()}]
	}
	JavaScriptBridge.eval("""
	window.parent.postMessage({
		type: 'applaa-game-save-score',
		gameId: 'catch-falling-objects',
		playerName: '""" + player_name + """',
		score: """ + str(score) + """
	}, '*');
	""")

func load_game_data():
	JavaScriptBridge.eval("""
	window.parent.postMessage({
		type: 'applaa-game-load-data',
		gameId: 'catch-falling-objects'
	}, '*');
	""")
	# Note: In a real implementation, you'd listen for the response and update high_score accordingly