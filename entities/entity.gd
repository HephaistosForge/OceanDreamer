extends CharacterBody2D

class_name Entity 

signal death

@export var max_hp: int = 100
@export var is_enemy: bool = true

@onready var hp = max_hp : set = set_hp

var modulate_tween = null

func _ready():
	death.connect(despawn_with_animation)

func set_hp(new_hp):
	var delta = clamp(new_hp, 0, max_hp) - hp
	hp += delta
	
	if delta != 0:
		#var target_color = Color.RED if delta < 0 else Color.GREEN
		var ratio = delta / float(max_hp)
		var target_color = Color(0.6 - min(0, ratio), 0.6 + max(0, ratio), 0.6)
		if modulate_tween != null: modulate_tween.kill()
		modulate_tween = create_tween()
		modulate_tween.tween_property(self, "scale", Vector2.ONE * 0.95, 0.2) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		modulate_tween.parallel().tween_property(self, "modulate", target_color, 0.2) \
			.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
			
		modulate_tween.tween_property(self, "scale", Vector2.ONE, 0.3) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
		modulate_tween.parallel().tween_property(self, "modulate", Color.WHITE, 0.3) \
			.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUART)
			
	if hp == 0:
		death.emit()
	
func take_damage(damage):
	set_hp(hp - damage)
	
func despawn_with_animation():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 1) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(queue_free)
