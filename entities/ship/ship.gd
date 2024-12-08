extends Entity

@export var max_speed: int = 1000
@export var speed_multiplier: int = 2000
@export var rotation_speed: float = 2

@onready var cannon = $Cannon

func _ready():
	var level_manager = get_tree().get_first_node_in_group("level_manager")
	level_manager.to_next_level.connect(_on_next_level)
	super()
	
	death.connect(game_over)
	death.connect(level_manager.on_player_death)


func _physics_process(delta: float) -> void:
	var speed = (Input.get_action_strength("forward") \
		- Input.get_action_strength("backward")) * 0.2 * int(not dead)
	var turn = Input.get_axis("turn_left", "turn_right") * int(not dead)
	
	var rot_vec = Vector2(cos(rotation), sin(rotation))
	
	# When the boat is going fast, and then turns sideways, reduce the velocity
	# drastically, in order to show that it has more friction in that direction
	velocity *= max(0.9, pow(abs(rot_vec.normalized().dot(velocity.normalized())), 0.2))
	
	# reduce velocity continually in order to simulate friction
	velocity -= delta * velocity * 0.2
	
	# increase velocity if action is pressed
	velocity += speed * Vector2(cos(rotation), sin(rotation)) * speed_multiplier * delta
	
	# normalize velocity after soem max speed
	velocity /= max(1, velocity.length() / max_speed)
	
	# Rotate ship, and also rotate the velocity vector in that range, to simulate
	# the pressure difference on both sides of the ship
	var delta_rotate = turn * delta * rotation_speed
	velocity = velocity.rotated(delta_rotate / 2)
	rotate(delta_rotate)
	
	move_and_slide()


func _on_next_level(_level, upgrade: Upgrade) -> void:
	speed_multiplier = upgrade.fma("movement_speed", speed_multiplier)
	max_speed = upgrade.fma("max_speed", max_speed)
	max_hp = upgrade.fma("hp", max_hp)
	rotation_speed = upgrade.fma("rotation_speed", rotation_speed)
	hp = max_hp
	scale = Vector2.ONE * upgrade.fma("ship_size", scale.x)
	cannon.apply_upgrade(upgrade)


func game_over(_ignore) -> void:
	Audio.play("game_over")
	var tween = create_tween()
	tween.tween_property(self, "scale", scale * 0.7, 3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(self, "modulate", Color(0.3, 0.3, 0.6, 0.3), 3) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	
	dead = true
	for child in get_children():
		if child.is_in_group("cannon"):
			child.dead = true
