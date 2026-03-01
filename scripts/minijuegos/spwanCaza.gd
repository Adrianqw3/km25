extends Node2D

@export var ave_scene: PackedScene
@export var max_aves := 6
@export var spawn_area := Vector2(256,144)
@export var margen_fuera := 40

var aves := []

func _ready():
	randomize()
	spawn_inicial()

func spawn_inicial():
	for i in max_aves:
		spawn_one()

func spawn_one():
	if ave_scene == null:
		print("Asigna Ave.tscn en el inspector")
		return
		
	var ave = ave_scene.instantiate()
	
	# Posición FUERA de pantalla
	var side = randi() % 4
	var pos := Vector2.ZERO
	
	match side:
		0: pos = Vector2(-margen_fuera, randf_range(0, spawn_area.y)) # izquierda
		1: pos = Vector2(spawn_area.x + margen_fuera, randf_range(0, spawn_area.y)) # derecha
		2: pos = Vector2(randf_range(0, spawn_area.x), -margen_fuera) # arriba
		3: pos = Vector2(randf_range(0, spawn_area.x), spawn_area.y + margen_fuera) # abajo
	
	ave.position = pos
	
	add_child(ave)
	aves.append(ave)
	
	# Escuchar cuando muere
	ave.connect("ave_eliminada", Callable(self, "_on_ave_muerta"))

func _on_ave_muerta():
	await get_tree().create_timer(1.0).timeout
	spawn_one()
