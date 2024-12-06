extends Node2D

const CANNONBALL_SCENE = preload("res://entities/weapons/cannonball.tscn")

@export var rotation_speed: float = 10.0
@export var shooting_delay: float = 0.5
@export var velocity: float = 300

var reload_timer: Timer = Timer.new()
var can_shoot = true

func _ready():
	add_child(reload_timer)
	reload_timer.wait_time = shooting_delay
	reload_timer.timeout.connect(func(): can_shoot = true)
	

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	#var target = global_position.angle_to(get_global_mouse_position())
	#global_rotation = rotate_toward(global_rotation, target, delta * rotation_speed)
	
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		reload_timer.start()
		var cannonball = CANNONBALL_SCENE.instantiate()
		get_tree().root.add_child(cannonball)
		cannonball.global_position = global_position
		cannonball.velocity = Vector2(cos(global_rotation), sin(global_rotation)) * velocity
		
		
