extends CharacterBody2D

const plane_states = {
	'full_health':"res://assets/Foozle_2DS0011_Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Full health.png",
	'slightly_damaged':"res://assets/Foozle_2DS0011_Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Slight damage.png",
	'very_damaged':"res://assets/Foozle_2DS0011_Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Very damaged.png",
	'damaged':"res://assets/Foozle_2DS0011_Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Damaged.png"
}
const plane_sprites = [
	"res://assets/Foozle_2DS0011_Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Very damaged.png",
	"res://assets/Foozle_2DS0011_Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Damaged.png",
	"res://assets/Foozle_2DS0011_Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Slight damage.png",
	"res://assets/Foozle_2DS0011_Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Full health.png"
					]
const SPEED = 100.0

@onready var plane_sprite: Sprite2D = $Plane
@onready var firing_positions: Node2D = $FiringPositions
@onready var fire_delay_timer: Timer = $Timers/FireDelayTimer 
@onready var invc_timer: Timer = $Timers/InvcTimer
@onready var shield_sprite: Sprite2D = $Shield

@export var fire_delay = 0.2 

signal upadte_ui(hp:int,direction:int)

var bullet_scene = preload("res://Scenes/bullets.tscn")
var HP := 4:
	set(value): 
		upadte_ui.emit(value,value-HP)
		HP = value

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
	if not invc_timer.is_stopped():
		return
	invc_timer.start()
	HP -= amount
	print(HP) 
	if HP <=0:
		queue_free()
	change_plane_sprite()
	shield_sprite.visible = true

func change_plane_sprite():
	plane_sprite.texture = load(plane_sprites[HP-1])

func _on_invc_timer_timeout() -> void:
	shield_sprite.visible = false
