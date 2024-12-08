extends RigidBody2D

var ship = null : set = setship

var tween

func setship(new_ship):
	ship = new_ship
	if new_ship == null:
		return
	tween = create_tween()
	var to = get_parent().find_child("Finger").global_position
	tween.tween_property(ship, "global_position", to, 0.6) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)

func _physics_process(delta: float) -> void:
	if ship:
		self.apply_force(ship.velocity * 4000)
		ship.velocity *= Vector2.ZERO
		if tween == null or not tween.is_running():
			var to = get_parent().find_child("Finger").global_position
			ship.global_position = to
		
