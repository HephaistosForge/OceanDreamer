extends CharacterBody2D

class_name Entity 

const RIPPLE_SCENE = preload("res://effects/RippleEffect.tscn")
const DAMAGE_LABEL_SCENE = preload("res://ui_scenes/labels/damage_label.tscn")

signal death
signal hp_changed(new_value: float, old_value: float, max_hp: float)

@export var max_hp: float = 100
@export var is_enemy: bool = true
@export var ripple_scale: float = 0.8 * 4
@onready var hp = max_hp : set = set_hp

var dead = false

var ripple_effect: CPUParticles2D = null
var modulate_tween = null


func _ready():
	appear()
	
	ripple_effect = RIPPLE_SCENE.instantiate()
	self.add_child(ripple_effect)
	ripple_effect.scale_amount_max = ripple_scale
	ripple_effect.scale_amount_min = ripple_effect.scale_amount_max


func _process(delta: float) -> void:
	ripple_effect.lifetime = 2 * exp(-velocity.length() / 1000)


func set_hp(new_hp):
	if dead: return
	
	var delta = clamp(new_hp, 0, max_hp) - hp
	hp += delta
	
	if not is_zero_approx(delta):
		var label = DAMAGE_LABEL_SCENE.instantiate()
		get_tree().current_scene.add_child(label)
		label.global_position = global_position
		label.set_damage(delta)
		hp_changed.emit(new_hp, hp-delta, max_hp)
		
		#var target_color = Color.RED if delta < 0 else Color.GREEN
		var ratio = delta / max_hp
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
			
	if hp <= 0 or is_zero_approx(hp):
		death.emit(self)
		dead = true
	
func take_damage(damage):
	set_hp(hp - damage)
	
func appear():
	var initial_scale = scale
	scale *= 0.8
	var tween = create_tween()
	tween.tween_property(self, "scale", initial_scale, 0.6) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
func fade_in():
	var initial = modulate
	modulate = Color(1, 1, 1, 0)
	var tween = create_tween()
	tween.tween_property(self, "modulate", initial, 1.5) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
func despawn_with_animation(_ignore):
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(queue_free)
