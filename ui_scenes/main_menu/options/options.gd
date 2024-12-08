extends Control

@onready var music_slide = $HBoxContainer/VBoxContainer2/Musik/CenterContainer2/Music_Slide
@onready var music_val = $HBoxContainer/VBoxContainer2/Musik/MusicVal
@onready var sound_slide = $HBoxContainer/VBoxContainer2/Sound/CenterContainer/Sound_Slide
@onready var sound_val = $HBoxContainer/VBoxContainer2/Sound/SoundVal


func _ready() -> void:
	music_slide.value = get_music_volume()
	sound_slide.value = get_sound_volume()


func get_music_volume():
	return Audio.music_volume
	
	
func set_music_volume(value):
	Audio.set_music_volume(value)
	
	
func get_sound_volume():
	return Audio.sound_volume
	
	
func set_sound_volume(value):
	Audio.set_sound_volume(value)


func _on_sound_slide_value_changed(value: float) -> void:
	sound_val.text = str(value)
	set_sound_volume(value)


func _on_music_slide_value_changed(value: float) -> void:
	music_val.text = str(value)
	set_music_volume(value)


func _on_sound_slide_drag_ended(_value_changed: bool) -> void:
	Audio.play_sound_example()


func _on_back_pressed() -> void:
	_on_button_click()
	get_tree().change_scene_to_file("res://ui_scenes/main_menu/main_menu.tscn")


func _on_back_mouse_entered() -> void:
	_on_button_hover()


func _on_button_hover() -> void:
	Audio.play("button_hover")


func _on_button_click() -> void:
	Audio.play("button_select")
