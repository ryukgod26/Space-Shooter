class_name Enemy
extends Area2D

@export var SPEED := 10.
@export var HP := 3
@export var DAMAGE := 1 
@export var score_value = 1

var bullet_scene = preload("res://Scenes/enemy_bullet.tscn")
var enemy_explosion = preload("res://Scenes/enemy_explosion.tscn")

@onready var firing_positions: Node2D = $FiringPositions

signal score(amount: int)

var player = null

func _physics_process(delta: float) -> void:
	position.y  += SPEED*delta

func _process(_delta: float) -> void:
	if player != null:
		player.take_damage(DAMAGE)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func fire():
	for firing_position in firing_positions.get_children():
			var bullet = bullet_scene.instantiate()
			bullet.global_position = firing_position.global_position
			get_tree().current_scene.add_child(bullet)

func take_damage(amount: int):
	if HP <= 0:
		return
	HP -= amount
	if HP <= 0:
		var explosion = enemy_explosion.instantiate()
		explosion.global_position = global_position
		get_parent().add_child(explosion)
		score.emit(score_value)
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	print('Got Player')
	if body.is_in_group('Player'):
		print("Got Player 2")
		player = body

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group('Player'):
		player = null
