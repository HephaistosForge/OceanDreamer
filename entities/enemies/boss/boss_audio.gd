extends Node


func _ready() -> void:
	Audio.background_music_choice = 2
	Audio._on_background_music_finished()
