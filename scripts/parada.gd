extends Node2D

@onready var fondo: Sprite2D = $fondo
@onready var auto: AnimatedSprite2D = $auto/AnimatedSprite2D

var context_event: Dictionary
var minigame_event: Dictionary
var quest_events: Array


func _ready() -> void:
	if fondo == null:
		push_error("Sprite2D (fondo) no encontrado en la escena")
		return

	var path := Eventos.get_background_for_biome(MainScript.bioma_actual)
	if path != "":
		fondo.texture = load(path)

	# Eventos de esta parada
	context_event = Eventos.get_context_event(MainScript.bioma_actual)
	minigame_event = Eventos.get_minigame_event(MainScript.bioma_actual)
	quest_events = Eventos.get_quest_events(MainScript.bioma_actual)
	

	# Debug temporal
	print("Context:", context_event)
	print("Minigame:", minigame_event)
	print("Quests:", quest_events)

	# Entrada del auto
	_entrada_auto()
	_mostrar_eventos()

func _entrada_auto():
	auto.visible = true
	auto.modulate.a = 1.0

	var pos_final := auto.position
	auto.position.x = -150

	auto.play("detener")

	var tween := create_tween()
	tween.tween_property(auto, "position:x", pos_final.x, 0.6)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	tween.finished.connect(_on_auto_llego)

func _on_auto_llego():
	auto.play("estacionado")
	_spawn_quest_npcs()

func _mostrar_eventos():
	# Texto de contexto
	if not context_event.is_empty():
		print(context_event["description"])

	# Minijuego
	if minigame_event.has("minigame"):
		_cargar_minijuego(minigame_event["minigame"])

	# Quests activas
	for quest in quest_events:
		var step: int = Eventos.get_quest_checkpoint(quest["id"])
		print("Quest:", quest["id"], "Checkpoint:", step)


func _cargar_minijuego(id: String):
	var path := "res://minijuegos/%s.tscn" % id
	if not ResourceLoader.exists(path):
		return

	var packed_scene: PackedScene = load(path)
	var scene: Node = packed_scene.instantiate()
	add_child(scene)

	scene.finished.connect(_on_minigame_finished)


func _on_minigame_finished(result: Dictionary):
	print("Resultado minijuego:", result)

func _spawn_quest_npc(event: Dictionary) -> void:
	if not event.has("scene"):
		return
	var path: String = event["scene"]
	if not ResourceLoader.exists(path):
		push_error("No existe escena NPC: " + path)
		return

	var packed: PackedScene = load(path)
	var npc: Node2D = packed.instantiate()

	npc.position = Vector2(80, 30)
	add_child(npc)

func _spawn_quest_npcs() -> void:
	for quest in quest_events:
		var step: int = Eventos.get_quest_checkpoint(quest["id"])
		print("Spawn NPC:", quest["id"], "Checkpoint:", step)
		_spawn_quest_npc(quest)
