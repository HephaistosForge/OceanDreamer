extends Area2D

var velocity = Vector2.ZERO
var damage = 10
var is_enemy = true

func _physics_process(delta: float) -> void:
	position += velocity * delta


func _on_entity_entered(body: Node2D) -> void:
	if body is Entity and body.is_enemy != is_enemy:
		body.take_damage(damage)
		queue_free()
