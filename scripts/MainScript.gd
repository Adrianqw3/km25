extends Node

var work_duration :=60
var short_break_duration := 5 * 60
var long_break_duration := 15 * 60

var cycles_completed := 0
var is_working := true
var current_timer := 0

var time_left := 0.0
var time_total := 0.0
var timer := Timer.new()

var bioma_actual := ""
var historial_biomas := []
var BIOMAS = {
	#"costa": {
		#"valor": 1.0,
		#"conexiones": ["bosque", "valle"],
		#"trabajo_screens": ["costa_trabajo_1"],
		#"descanso_screens": ["costa_descanso_1"],
		#"puede_ser_inicio": true
	#},

	"bosque": {
		"valor": 1.3,
		"conexiones": ["costa", "valle", "montana"],
		"trabajo_screens": ["bosque_trabajo_1"],
		"descanso_screens": ["bosque_descanso_1"],
		"puede_ser_inicio": true
	},

	"valle": {
		"valor": 1.5,
		"conexiones": ["bosque", "costa", "montana", "desierto"],
		"trabajo_screens": ["valle_trabajo_1"],
		"descanso_screens": ["valle_descanso_1"],
		"puede_ser_inicio": true
	},

	#'montana": {
		#"valor": 2.0,
		#"conexiones": ["valle", "bosque", "nieve", "desierto"],
		#"trabajo_screens": ["montana_trabajo_1"],
		#"descanso_screens": ["montana_descanso_1"],
		#"puede_ser_inicio": false
	#},

	"desierto": {
		"valor": 2.3,
		"conexiones": ["valle", "montana"],
		"trabajo_screens": ["desierto_trabajo_1"],
		"descanso_screens": ["desierto_descanso_1"],
		"puede_ser_inicio": false
	},

	#"nieve": {
		#"valor": 3.5,
		#"conexiones": ["montana", "valle"],
		#"trabajo_screens": ["nieve_trabajo_1"],
		#"descanso_screens": ["nieve_descanso_1"],
		#"puede_ser_inicio": false
	#}
}

var PANTALLAS = {

	"bosque_trabajo_1":"res://pantallas/bosque.tscn" ,
	"valle_trabajo_1": "res://pantallas/valle.tscn",
	"desierto_trabajo_1":"res://pantallas/desierto.tscn" ,
	"descanso": "res://pantallas/parada.tscn"

}

func _ready():
	randomize()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timer_finished)

	bioma_actual = seleccionar_bioma_inicial()
	print("Bioma inicial:", bioma_actual)

	print("MainScript listo. Esperando que el jugador presione INICIO.")

func seleccionar_bioma_inicial() -> String:
	var random_valor = randf_range(0.0, 4.0)
	print("Valor aleatorio inicial:", random_valor)

	var bioma_mas_cercano = ""
	var mejor_diferencia = 999.0

	for bioma in BIOMAS.keys():
		if not BIOMAS[bioma]["puede_ser_inicio"]:
			continue

		var diff = abs(BIOMAS[bioma]["valor"] - random_valor)
		if diff < mejor_diferencia:
			mejor_diferencia = diff
			bioma_mas_cercano = bioma

	_agregar_a_historial(bioma_mas_cercano)
	return bioma_mas_cercano

func seleccionar_siguiente_bioma(bioma_actual:String, npc_forzado:String = "") -> String:
	if npc_forzado != "":
		_agregar_a_historial(npc_forzado)
		return npc_forzado

	var actual_valor = BIOMAS[bioma_actual]["valor"]
	var opciones = BIOMAS[bioma_actual]["conexiones"].duplicate()

	for reciente in historial_biomas:
		if reciente in opciones:
			opciones.erase(reciente)

	opciones = opciones.filter(func(b):
		return abs(BIOMAS[b]["valor"] - actual_valor) <= 1.5
	)


	if opciones.size() == 0:
		var fallback = _bioma_mas_cercano(bioma_actual)
		_agregar_a_historial(fallback)
		return fallback

	if opciones.size() == 2:
		var elegido = opciones[randi() % 2]
		_agregar_a_historial(elegido)
		return elegido

	if opciones.size() == 1:
		var unico = opciones[0]
		_agregar_a_historial(unico)
		return unico

	var mejor = _elegir_por_valor_cercano(actual_valor, opciones)
	_agregar_a_historial(mejor)
	return mejor


func _agregar_a_historial(bioma:String):
	historial_biomas.append(bioma)
	if historial_biomas.size() > 3:
		historial_biomas.pop_front()


func _bioma_mas_cercano(bioma_actual:String) -> String:
	var actual_valor = BIOMAS[bioma_actual]["valor"]
	var conexiones = BIOMAS[bioma_actual]["conexiones"]

	var mejor = conexiones[0]
	var mejor_diff = abs(BIOMAS[mejor]["valor"] - actual_valor)

	for b in conexiones:
		var diff = abs(BIOMAS[b]["valor"] - actual_valor)
		if diff < mejor_diff:
			mejor = b
			mejor_diff = diff

	return mejor

func _elegir_por_valor_cercano(valor_actual:float, opciones:Array) -> String:
	opciones.sort_custom(func(a, b):
		return abs(BIOMAS[a]["valor"] - valor_actual) < abs(BIOMAS[b]["valor"] - valor_actual)
	)
	return opciones[0]

func seleccionar_pantalla_trabajo(bioma:String) -> String:
	var pantallas = BIOMAS[bioma]["trabajo_screens"]
	var pick = pantallas[randi() % pantallas.size()]
	return PANTALLAS[pick]


func _start_work_cycle():
	current_timer = work_duration
	is_working = true
	time_total = work_duration
	time_left = work_duration
	timer.start(work_duration)

	print("Inicio de trabajo en bioma:", bioma_actual)
	var pantalla = seleccionar_pantalla_trabajo(bioma_actual)
	get_tree().change_scene_to_file(pantalla)

func _start_short_break():
	current_timer = short_break_duration
	is_working = false
	time_total = short_break_duration
	time_left = short_break_duration
	timer.start(short_break_duration)

	print("Descanso corto en bioma:", bioma_actual)
	Eventos.get_context_event(bioma_actual)
	Eventos.get_background_for_biome(bioma_actual)
	get_tree().change_scene_to_file(PANTALLAS['descanso'])


func _start_long_break():
	current_timer = long_break_duration
	is_working = false
	time_total = long_break_duration
	time_left = long_break_duration
	timer.start(long_break_duration)

	print("Descanso LARGO en bioma:", bioma_actual)
	Eventos.get_random_event(bioma_actual)
	get_tree().change_scene_to_file(PANTALLAS['descanso'])


func _on_timer_finished():
	if is_working:
		cycles_completed += 1

		if cycles_completed % 4 == 0:
			_start_long_break()
		else:
			_start_short_break()
	else:
		bioma_actual = seleccionar_siguiente_bioma(bioma_actual)
		print("Nuevo bioma:", bioma_actual)
		_start_work_cycle()
		
func _process(delta):
	if timer.is_stopped():
		return

	time_left -= delta
	time_left = max(time_left, 0)
