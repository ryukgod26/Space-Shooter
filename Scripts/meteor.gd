extends Area2D


@export var min_speed := 40.
@export var max_speed := 60.
@export var min_rotation_rate := -10.
@export var max_rotation_rate := 20.
@export var hp := 10

var speed := 0.
var rotation_rate := 0.

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	speed = rng.randf_range(min_speed,max_speed)
	rotation_rate = rng.randf_range(min_rotation_rate,max_rotation_rate)
	
func _process(delta: float) -> void:
	rotation_degrees += rotation_rate * delta
	position.y += speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func take_damage(amount: int):
	hp -= amount
	if hp <= 0:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.has_method('take_damage'):
		body.take_damage(1)
