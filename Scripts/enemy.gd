extends Area2D

@export var SPEED = 10

func _physics_process(delta: float) -> void:
	position.y  += SPEED*delta
