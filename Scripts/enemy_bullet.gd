extends Area2D

var bullet_effect_scene = preload("res://Scenes/enemy_bullet_effect.tscn")
@export var SPEED = 100
@export var DAMAGE = 1

func _physics_process(delta: float) -> void:
	position.y += SPEED * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method('take_damage'):
		var bullet_effect = bullet_effect_scene.instantiate()
		bullet_effect.position = position
		get_parent().add_child(bullet_effect)
		area.take_damage(DAMAGE)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		var bullet_effect = bullet_effect_scene.instantiate()
		bullet_effect.position = position
		get_parent().add_child(bullet_effect)
		body.take_damage(DAMAGE)
		queue_free()
