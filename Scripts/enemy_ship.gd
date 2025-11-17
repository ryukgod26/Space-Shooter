extends Enemy
class_name Enemy_shooter

@onready var fire_timer: Timer = $FireTimer

func _ready() -> void:
	HP = 15
	SPEED = 25
	score_value = 2
	
func _process(_delta: float) -> void:
	if fire_timer.is_stopped():
			fire()
			fire_timer.start()
	
