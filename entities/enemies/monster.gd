extends Entity

@export var speed: float = 100

func _physics_process(delta: float) -> void:
	var ship = get_tree().get_first_node_in_group("ship")
	if ship:
		look_at(ship.global_position)
		velocity = Vector2(cos(rotation), sin(rotation)) * speed
	move_and_slide()
 
