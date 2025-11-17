extends Node2D

@onready var spawn_timer: Timer = $SpawnTimer
const MIN_SPAWN_TIME := 1.5

@onready var ui: Control = $"../../UI"

var preloaded_enemies = [
	preload("res://Scenes/ufo.tscn"),
	preload("res://Scenes/enemy_ship.tscn"),
	preload("res://Scenes/bouncing_enemy.tscn")
]

var plMeteor = 	preload("res://Scenes/meteor.tscn")

var nextspawntime := 5.0
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	randomize()
	spawn_timer.start(nextspawntime)


func _on_spawn_timer_timeout() -> void:
	var view_rect := get_viewport_rect()
	var xPos := randf_range(view_rect.position.x,view_rect.end.x)
	if randf() < 0.1:
		var meteor = plMeteor.instantiate()
		meteor.position = Vector2(xPos,position.y)
		meteor.connect('score',update_score)
		get_parent().add_child(meteor)
	else:
		var enemyPreload = preloaded_enemies.pick_random()
		var enemy = enemyPreload.instantiate()
		enemy.position = Vector2(xPos,position.y)
		enemy.connect('score',update_score)
		get_parent().add_child(enemy)
	nextspawntime -= 0.1
	if nextspawntime < MIN_SPAWN_TIME:
		nextspawntime = MIN_SPAWN_TIME
	spawn_timer.start(nextspawntime)

func update_score(amount: int):
	print('Signal Received')
	ui.score_increment(amount)
