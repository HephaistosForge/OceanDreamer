extends CharacterBody2D

class_name Entity 

signal death

@export var max_hp: int = 100
@export var is_enemy: bool = true

@onready var hp = max_hp : set = set_hp

func _ready():
	death.connect(despawn_with_animation)

func set_hp(new_hp):
	hp = clamp(new_hp, 0, max_hp)
	if hp == 0:
		death.emit()
	
func take_damage(damage):
	set_hp(hp - damage)
	
func despawn_with_animation():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(queue_free)
