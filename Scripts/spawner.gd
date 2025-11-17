extends Node2D

@onready var power_up_spawn_timer: Timer = $PowerUpSpawnTimer
@onready var spawn_timer: Timer = $SpawnTimer
const MIN_SPAWN_TIME := 1.5

@onready var ui: Control = $"../../UI"

var preloaded_enemies = [
	preload("res://Scenes/ufo.tscn"),
	preload("res://Scenes/enemy_ship.tscn"),
	preload("res://Scenes/bouncing_enemy.tscn")
]

var preloaded_powerups =[
	preload("res://Scenes/shield_power_up.tscn"),
	preload("res://Scenes/rapid_fire_powerup.tscn")
]

var plMeteor = 	preload("res://Scenes/meteor.tscn")

var nextspawntime := 5.0
var min_power_up_spawn_time := 6.0
var max_power_up_spawn_time := 12.0
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	randomize()
	spawn_timer.start(nextspawntime)
	power_up_spawn_timer.start(min_power_up_spawn_time)

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


func _on_power_up_spawn_timer_timeout() -> void:
	var view_rect := get_viewport_rect()
	var xPos := randf_range(view_rect.position.x,view_rect.end.x)
	var power_up_preload = preloaded_powerups.pick_random()
	var powerup = power_up_preload.instantiate()
	powerup.position =  Vector2(xPos,position.y)
	get_tree().current_scene.add_child(powerup)
	power_up_spawn_timer.start(rng.randf_range(min_power_up_spawn_time,max_power_up_spawn_time))
	
