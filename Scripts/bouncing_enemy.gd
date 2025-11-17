extends Enemy_shooter

@export var horizontal_speed = 90

var horizontalDirection := 1

func _ready() -> void:
	score_value = 3

func _physics_process(delta: float) -> void:
	position.x += horizontal_speed * delta * horizontalDirection
	
	var view_rect = get_viewport_rect()
	if position.x < view_rect.position.x or position.x > view_rect.end.x:
		horizontalDirection *= -1
		
