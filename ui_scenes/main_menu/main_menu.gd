extends Control

const CREDITS_PREFAB = preload("res://ui_scenes/main_menu/credits/Credits.tscn")
const OPTIONS_PREFAB = preload("res://ui_scenes/main_menu/options/options.tscn")
const HOW_TO_PLAY_PREFAB = preload("res://ui_scenes/main_menu/how_to_play/how_to_play.tscn")

const MAIN_SCENE_PATH: String = ""

enum display_types {
	OPTIONS,
	CREDITS,
	MULTIPLAYER,
	MULTIPLAYER_LOBBY,
	HOW_TO_PLAY
}

var max_parallax = 20000
var currently_displayed = null
var currently_displayed_type = null
var target: Vector2 = Vector2.ZERO
var curr: Vector2 = Vector2.ZERO
var speed = 20


func _ready() -> void:
	target = get_random_target()

func _process(delta: float) -> void:
	curr += curr.direction_to(target).normalized() * delta * speed
	if curr.distance_to(target) <= 20:
		target = get_random_target()
	
	if currently_displayed == null:
		return 
	if currently_displayed_type == display_types.CREDITS:
		currently_displayed.position.y -= 30 * delta

func get_random_target():
	return Vector2(randi_range(-max_parallax, max_parallax), randi_range(-max_parallax, max_parallax))
	
	
func _on_play_pressed() -> void:
	_on_button_click()
	get_tree().change_scene_to_file(MAIN_SCENE_PATH)


func _on_options_pressed() -> void:
	if currently_displayed != null:
		currently_displayed.queue_free()
	var options = OPTIONS_PREFAB.instantiate()
	$MarginContainer/VBoxContainer.add_child(options)
	currently_displayed = options
	currently_displayed_type = display_types.OPTIONS
	_on_button_click()


func _on_credits_pressed() -> void:
	if currently_displayed != null:
		currently_displayed.queue_free()
	var credits = CREDITS_PREFAB.instantiate()
	$MarginContainer/VBoxContainer.add_child(credits)
	currently_displayed = credits
	currently_displayed_type = display_types.CREDITS
	_on_button_click()


func _on_exit_pressed() -> void:
	_on_button_click()
	get_tree().quit()


func _on_button_hover() -> void:
	AudioManager.play_button_hover()


func _on_button_click() -> void:
	AudioManager.play_button_click()


func _on_how_to_play_pressed() -> void:
	if currently_displayed != null:
		currently_displayed.queue_free()
	var how_to_play = HOW_TO_PLAY_PREFAB.instantiate()
	$MarginContainer/VBoxContainer.add_child(how_to_play)
	currently_displayed = how_to_play
	currently_displayed_type = display_types.HOW_TO_PLAY
