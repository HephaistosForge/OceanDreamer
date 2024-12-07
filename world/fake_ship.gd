extends RigidBody2D

var ship = null

func _physics_process(delta: float) -> void:
	if ship:
		self.apply_force(ship.velocity * 4000)
		ship.velocity *= Vector2.ZERO
		ship.global_position = get_parent().find_child("Finger").global_position
