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
@onready var cam := %ShakeCam
@onready var rapid_fire_timer: Timer = $Timers/RapidFireTimer

@export var fire_delay = 0.2 

var normal_fire_delay = fire_delay
var rapid_fire_delay = 0.08
signal upadte_ui(hp:int,direction:int)
signal game_over

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
	
	HP -= amount
	print(HP) 
	apply_shield(2.0)
	cam.shake(10)
	if HP <=0:
		game_over.emit()
		queue_free()
	change_plane_sprite()

func change_plane_sprite():
	plane_sprite.texture = load(plane_sprites[HP-1])

func _on_invc_timer_timeout() -> void:
	shield_sprite.visible = false

func apply_shield(time: float) -> void:
	invc_timer.start(time + invc_timer.time_left)
	shield_sprite.visible = true

func apply_rapid_fire(time: float):
	fire_delay = rapid_fire_delay
	rapid_fire_timer.start(time + rapid_fire_timer.time_left)


func _on_rapid_fire_timer_timeout() -> void:
	fire_delay = normal_fire_delay
