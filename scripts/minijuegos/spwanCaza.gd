extends Node2D

@export var ave_scene: PackedScene
@export var max_aves: int = 6
@export var spawn_area: Vector2 = Vector2(256,144)

var aves := []

func _ready():
	randomize()
	spawn_aves()

func spawn_aves():
	for i in max_aves:
		spawn_one()

func spawn_one():
	if ave_scene == null:
		print("Asigna Ave.tscn en el inspector")
		return

	var ave = ave_scene.instantiate()

	var x = randf_range(0, spawn_area.x)
	var y = randf_range(0, spawn_area.y)
	ave.position = Vector2(x, y)

	add_child(ave)
	aves.append(ave)
