extends Control


func _on_button_hover() -> void:
	Audio.play("button_hover")


func _on_button_click() -> void:
	Audio.play("button_select")


func _on_back_options_pressed() -> void:
	_on_button_click()
	get_tree().change_scene_to_file("res://ui_scenes/main_menu/main_menu.tscn")


func _on_back_options_mouse_entered() -> void:
	_on_button_hover()
