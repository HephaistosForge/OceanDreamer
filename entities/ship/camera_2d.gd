extends Camera2D

@onready var original_position = position


func trigger_shake(intensity_factor: float, duration: float, amount_of_shakes: int, rotation: float) -> void:
	await get_tree().create_timer(0.1).timeout

	var tween = create_tween()

	for i in range(0, amount_of_shakes):
		# Calculate direction opposite to rotation
		var angle = rotation + PI
		var normalized_direction_vec = Vector2(cos(angle), sin(angle))
		var shake_offset = normalized_direction_vec * intensity_factor * 100

		tween.tween_property(self, "position", original_position + shake_offset, duration)

	tween.tween_property(self, "position", original_position, duration)
