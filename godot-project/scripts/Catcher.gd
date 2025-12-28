extends CharacterBody2D

const SPEED = 300.0

func _physics_process(delta):
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Keep within screen bounds
	position.x = clamp(position.x, 50, 750)
	
	move_and_slide()

func _on_area_entered(area):
	if area.is_in_group("falling_object"):
		Global.add_score(1)
		area.queue_free()