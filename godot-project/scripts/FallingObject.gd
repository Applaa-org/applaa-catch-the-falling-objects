extends Area2D

var speed: float = 100.0

func _process(delta):
	position.y += speed * delta
	
	if position.y > 650:
		Global.lose_life()
		queue_free()