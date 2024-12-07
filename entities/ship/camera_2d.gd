extends Camera2D

@onready var original_position = position


func trigger_shake(intensity_factor: float, duration: float, amount_of_shakes: int, angle: float) -> void:
	await get_tree().create_timer(0.1).timeout

	var tween = create_tween()

	for i in amount_of_shakes:
		# Calculate direction opposite to rotation
		var opposite_angle = angle + PI
		var normalized_direction_vec = Vector2(cos(opposite_angle), sin(opposite_angle))
		var shake_offset = normalized_direction_vec * intensity_factor * 100

		tween.tween_property(self, "position", original_position + shake_offset, duration)

	tween.tween_property(self, "position", original_position, duration)
