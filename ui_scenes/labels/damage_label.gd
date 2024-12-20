extends Node2D

@onready var label = $Label

func set_damage(damage):
	label.text = round(damage)
	modulate = Color("0be876") if damage > 0 else Color("e20d51")
	label.label_settings.font_size = 18 * (log(abs(damage)+1)+1)
	var tween = create_tween()
	tween.tween_property(self, "position", global_position+Vector2(0, -200), 0.6) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate", Color(0, 0, 0, 0), 0.6) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_callback(queue_free)
