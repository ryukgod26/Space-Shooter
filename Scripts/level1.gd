extends Node

@onready var ui: Control = $UI
@onready var player: CharacterBody2D = %Player

func _ready() -> void:
	ui.setup(player.HP)

func _on_player_upadte_ui(hp: int, direction: int) -> void:
	print("HP:",hp,"Direction:",direction)
	ui.update_health(hp,direction)
