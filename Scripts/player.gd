extends CharacterBody2D


const SPEED = 100.0

@onready var firing_positions: Node2D = $FiringPositions
@onready var fire_delay_timer: Timer = $Timers/FireDelayTimer


@export var fire_delay = 0.2 

var bullet_scene = preload("res://Scenes/bullets.tscn")
var HP := 5

func _physics_process(_delta: float) -> void:

	velocity.x = 0
	velocity.y = 0

	if Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
	if Input.is_action_pressed("move_up"):
		velocity.y = -SPEED
	if Input.is_action_pressed("move_down"):
		velocity.y = SPEED
	if Input.is_action_pressed("shoot") and fire_delay_timer.is_stopped():
		fire_delay_timer.start(fire_delay)
		for firing_position in firing_positions.get_children():
			var bullet = bullet_scene.instantiate()
			bullet.global_position = firing_position.global_position
			get_tree().current_scene.add_child(bullet)
	
	var viewRect := get_viewport_rect()
	position.x = clamp(position.x,0,viewRect.size.x)
	position.y = clamp(position.y,0,viewRect.size.y)
	
	move_and_slide()

func take_damage(amount: int):
	HP -= amount
	print(HP)
	if HP <=0:
		queue_free()
