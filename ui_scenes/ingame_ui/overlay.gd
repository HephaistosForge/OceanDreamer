extends CanvasLayer

var UPGRADE_DIALOG_SCENE = preload("res://ui_scenes/ingame_ui/upgrade_dialog.tscn")


func _on_level_manager_remaining_progress(count: Variant, total: Variant) -> void:
	var label = $CenterContainer/Top/HBoxContainer/EnemyKillCountRequirementLabel
	label.text = str(count) + "/" + str(total)


func _on_level_manager_to_upgrade_screen(upgrades) -> void:
	var dialog = UPGRADE_DIALOG_SCENE.instantiate()
	dialog.show_and_pick_upgrades(upgrades)
	$CenterContainer/Expander/HBoxContainer/LeftHalf.add_child(dialog)
