extends Node

var completed_events := {}
var quest_progress:={}
var current_event:={}

var biome_backgroung :={
	"bosque":"res://spirtes/fondos/bosque fondo.png",
	"desierto":"res://spirtes/fondos/desierto_fondo.png",
	"valle":"res://spirtes/fondos/valle_fondo.png"
}

var events:=[{
		#"id": "gasolinera",
		#"type": "minigame",
		#"repeatable": true,
		#"biomes": [], # vacío = cualquier bioma
		#"scene": "res://eventos/gasolinera.tscn",
		#"description": "Una gasolinera vieja y silenciosa."
},
{		"id": "pescador",
		"type": "quest",
		"repeatable": true,
		"biomes": ["costa", "manglar"],
		"scene": "res://eventos/pescador.tscn",
		"description": "Un pescador observa el agua sin decir palabra."},

{
		"id": "perro",
		"type": "quest",
		"repeatable": false,
		"biomes": ['bosque','valle','descierto'],
		"scene": "res://pantallas/npcs/prro.tscn",
		"checkpoints": [
			"El perro aparece a la distancia.",
			"Te sigue sin hacer ruido.",
			"Desaparece al amanecer."
		]},{
		"id":"ovni",
		"type":"quest",
		"repeatable":false,
		"scene":"res://pantallas/npcs/ovni.tscn",
		"biomes":['bosque','valle','descierto']
		}]
		

func get_context_event(bioma: String) -> Dictionary:
	return _get_event_by_type("narrative", MainScript.bioma_actual)

func get_minigame_event(bioma: String) -> Dictionary:
	bioma=MainScript.bioma_actual
	return _get_event_by_type("minigame", MainScript.bioma_actual)
	

func _get_event_by_type(type: String, bioma: String) -> Dictionary:
	var pool: Array = []

	for event: Dictionary in events:
		if not event.has("type"):
			continue
		if event["type"] != type:
			continue

		if event.has("biomes") and event["biomes"].size() > 0:
			if not bioma in event["biomes"]:
				continue

		pool.append(event)

	if pool.is_empty():
		return {}

	return pool.pick_random()

func get_quest_events(bioma: String, max_count: int = 2) -> Array:
	var pool: Array = []

	for event: Dictionary in events:
		if event.get("type", "") != "quest":
			continue

		var id: String = event["id"]

		if not EstadosNpc.has_npc(id):
			continue

		if EstadosNpc.is_completed(id):
			continue

		if event.has("biomes") and event["biomes"].size() > 0:
			if not bioma in event["biomes"]:
				continue

		pool.append(event)

	pool.shuffle()
	return pool.slice(0, min(max_count, pool.size()))

func get_quest_checkpoint(id: String) -> int:
	return EstadosNpc.get_state(id)

func get_background_for_biome(biome:String)->String:
	return biome_backgroung.get(biome,"") as String
	
