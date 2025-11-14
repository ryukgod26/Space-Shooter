extends Area2D

@export var SPEED := 500.
@export var DAMAGE := 1

func _physics_process(delta: float) -> void:
	position.y -= SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.has_method('take_damage'):
		area.take_damage(DAMAGE)
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('take_damage'):
		body.take_damage(DAMAGE)
		queue_free()
