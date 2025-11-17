class_name PowerUp
extends Area2D

@export var power_up_move_speed := 50

func _physics_process(delta: float) -> void:
	position.y += power_up_move_speed * delta
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group('Player'):
		applyPowerUp(body)
		queue_free()

func applyPowerUp(body):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
