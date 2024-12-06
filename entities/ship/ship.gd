extends Entity

@export var max_speed: int = 1000

func _physics_process(delta: float) -> void:
	var speed = Input.get_action_strength("forward") \
		- Input.get_action_strength("backward") * 0.2
	var turn = Input.get_axis("turn_left", "turn_right")
	
	var rot_vec = Vector2(cos(rotation), sin(rotation))
	
	# When the boat is going fast, and then turns sideways, reduce the velocity
	# drastically, in order to show that it has more friction in that direction
	velocity *= max(0.9, pow(abs(rot_vec.normalized().dot(velocity.normalized())), 0.2))
	
	# reduce velocity continually in order to simulate friction
	velocity -= delta * velocity * 0.2
	
	# increase velocity if action is pressed
	velocity += speed * Vector2(cos(rotation), sin(rotation)) * 2000 * delta
	
	# normalize velocity after soem max speed
	velocity /= max(1, velocity.length() / max_speed)
	
	velocity = velocity.rotated(turn * delta)
	rotate(turn * delta * 2)
	
	move_and_slide()


	
