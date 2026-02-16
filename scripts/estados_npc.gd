extends Node

var player_name:String

var npcs := {
	"perro": {
		"conocido": false,
		"iniciada": false,
		"estado": 0,
		"estadofin": 5,
		"completada": false,
		"abandonada": false
	},
	"ovni": {
		"conocido": false,
		"iniciada": false,
		"estado": 0,
		"completada": false,
		"abandonada": false
	}
}

func has_npc(id: String) -> bool:
	return npcs.has(id)

func get_npc(id: String) -> Dictionary:
	return npcs.get(id, {})

func get_state(id: String) -> int:
	return npcs.get(id, {}).get("estado", 0)

func is_completed(id: String) -> bool:
	return npcs.get(id, {}).get("completada", false)
