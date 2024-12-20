extends Camera2D

const MIN_ZOOM = 0.5
const MAX_ZOOM = 4

@onready var original_position = position
@onready var initial_zoom = zoom
var zoom_factor = 1
@onready var dream_zoom = zoom
@onready var reality_zoom = zoom / 2.5

func _unhandled_input(event: InputEvent) -> void:
	var axis = (int(event.is_action_pressed("zoom_out")) - int(event.is_action_pressed("zoom_in"))) / 4.0
	if not is_zero_approx(axis):
		zoom_factor = clamp(zoom_factor*(1+axis), MIN_ZOOM, MAX_ZOOM)
		dream_zoom = initial_zoom * zoom_factor
		var tween = create_tween()
		tween.tween_property(self, "zoom", dream_zoom, 0.1) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		


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
