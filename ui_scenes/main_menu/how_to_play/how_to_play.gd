extends Control

const TUTORIAL_ITEM_PREFAB = preload("res://ui_scenes/main_menu/how_to_play/how_to_play_item.tscn")

var tutorial_items = [
	[
		preload("res://icon.svg"), 
		"Headline", 
		"Body"
	],	
	[
		preload("res://icon.svg"), 
		"Headline", 
		"Body"
	],
	[
		preload("res://icon.svg"), 
		"Headline", 
		"Body"
	],
	[
		preload("res://icon.svg"), 
		"Headline", 
		"Body"
	],
	[
		preload("res://icon.svg"), 
		"Headline", 
		"Body"
	]
	
]


# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#for item in tutorial_items:
		#var tut_item = TUTORIAL_ITEM_PREFAB.instantiate()
		#$MarginContainer/ScrollContainer/CenterContainer/GridContainer.add_child(tut_item)
		#tut_item.init(item[0], item[1], item[2])
		

func _on_back_pressed() -> void:
	_on_button_click()
	get_tree().change_scene_to_file("res://ui_scenes/main_menu/main_menu.tscn")


func _on_back_mouse_entered() -> void:
	_on_button_hover()


func _on_button_hover() -> void:
	Audio.play("button_hover")


func _on_button_click() -> void:
	Audio.play("button_select")
