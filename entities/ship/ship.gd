extends Entity

func _physics_process(delta: float) -> void:
	var speed = Input.get_action_strength("forward") \
		- Input.get_action_strength("backward") * 0.2
	var turn = Input.get_axis("turn_left", "turn_right")
	
	velocity -= delta * velocity
	velocity += speed * Vector2(cos(rotation), sin(rotation)) * 2000 * delta
	
	rotate(turn * delta * 2)
	
	move_and_slide()


	
