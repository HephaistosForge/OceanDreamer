extends VBoxContainer

@onready var music_slide = $Musik/CenterContainer2/Music_Slide
@onready var music_val = $Musik/MusicVal
@onready var sound_slide = $Sound/CenterContainer/Sound_Slide
@onready var sound_val = $Sound/SoundVal


func _ready() -> void:
	music_slide.value = get_music_volume()
	sound_slide.value = get_sound_volume()


func get_music_volume():
	return AudioManager.music_volume
	
	
func set_music_volume(value):
	AudioManager.set_music_volume(value)
	
	
func get_sound_volume():
	return AudioManager.sound_volume
	
	
func set_sound_volume(value):
	AudioManager.set_sound_volume(value)


func _on_sound_slide_value_changed(value: float) -> void:
	sound_val.text = str(value)
	set_sound_volume(value)


func _on_music_slide_value_changed(value: float) -> void:
	music_val.text = str(value)
	set_music_volume(value)


func _on_sound_slide_drag_ended(_value_changed: bool) -> void:
	AudioManager.play_sound_example()

