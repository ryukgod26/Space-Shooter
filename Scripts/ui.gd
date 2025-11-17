extends Control

@onready var heart_container = $Hearts/MarginContainer/HBoxContainer

var heart_scene = preload("res://Scenes/heart.tscn")
var score: int = 0

func setup(val: int) -> void:
	print("val:",val)
	for i in range(val):
		var heart = heart_scene.instantiate()
		heart_container.add_child(heart)
		heart.change_alpha(1.0)
		await get_tree().create_timer(0.4).timeout

func update_health(value: int,direction: int) -> void:
	for heart in heart_container.get_children():
		heart.queue_free()
	if direction < 0:
		for i in value:
			var heart = heart_scene.instantiate()
			heart_container.add_child(heart)
		var loosen_heart = heart_scene.instantiate()
		heart_container.add_child(loosen_heart)
		loosen_heart.change_alpha(0.0)
	else:
		for i in value -1:
			var heart = heart_scene.instantiate()
			heart_container.add_child(heart)
		var gained_heart = heart_scene.instantiate()
		heart_container.add_child(gained_heart)
		gained_heart.change_alpha(1.0)

func score_increment(amount: int):
	score += amount
	$Score.text = str(score).pad_zeros(3)
