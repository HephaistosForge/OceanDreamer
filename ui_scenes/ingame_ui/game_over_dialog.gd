extends CenterContainer


func _on_upgrade_item_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		Audio.play("button_select")
		get_tree().reload_current_scene.call_deferred()


func _on_upgrade_item_mouse_entered() -> void:
	Audio.play("button_hover")
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate", Color(0.7, 0.7, 0.7, 1), .1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)


func _on_upgrade_item_mouse_exited() -> void:
	var tween = create_tween()
	tween.parallel().tween_property(self, "modulate", Color.WHITE, .1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
