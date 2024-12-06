extends Control

const bold = preload("res://ui_scenes/fonts/NovaSquare-Regular.ttf")
const light = preload("res://ui_scenes/fonts/NovaSquare-Regular.ttf")
const regular = preload("res://ui_scenes/fonts/NovaSquare-Regular.ttf")

const GAME_TITLE = "<GAME_TITLE>"

var music = ["Music", 
["Title", "Author", "License"]
]


var shader = ["Shaders",
["Title", "Author", "License"],
["Title", "Author", "License"]
]


var sound = ["Sound Design",
["Dummy 1",null, null]
]


var art = ["Artists",
["Dummy 1", null, null],
["Dummy 2",null, null],
]


var programing = ["Programmers",
["Dummy 1",null, null],
["Dummy 2",null, null],
["Dummy 3",null, null]
]


var thanks = ["Thanks for Playing!"]

var licensing = ["",
	[
		GAME_TITLE +"\n A game by Hephaistos' Forge","2024","MIT License"
	]
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_credits()


func create_credits():
	for section in [programing, art, sound, music, thanks, licensing]:
		var section_container = VBoxContainer.new()
		section_container.add_theme_constant_override("separation", 0)
		var section_header = Label.new()
		format_label(section_header, bold, 50)
		section_header.text = section.pop_front()
		
		self.add_child(section_header)
		for item in section:
			var item_container = VBoxContainer.new()
			item_container.add_theme_constant_override("separation", 2)
			
			var name_label = Label.new()
			var author = Label.new()
			var license = Label.new()
			
			name_label.text = item[0] if item[0] != null else ""
			author.text = item[1] if item[1] != null else ""
			license.text = "licensed under " + item[2] if item[2] != null else ""
			
			format_label(name_label, regular, 20)
			format_label(author, regular, 15)
			format_label(license, light, 10)
			
			item_container.add_child(name_label)
			item_container.add_child(author)
			item_container.add_child(license)
			section_container.add_child(item_container)
		self.add_child(section_container)


func format_label(label, font, font_size, alignment = HORIZONTAL_ALIGNMENT_CENTER):
	label.horizontal_alignment = alignment
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", font_size)
