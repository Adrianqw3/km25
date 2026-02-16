extends Node2D

@export var speed := 30.0          
@onready var fondo_a: Sprite2D = $BosqueFondo
@onready var fondo_b: Sprite2D = $BosqueFondo2

var width := 0
var offset := 0.0

func _ready() -> void:

	width = int(fondo_a.texture.get_width())
	if width <= 0:
		push_error("La textura del fondo no tiene ancho válido.")
		return


	fondo_a.scale = Vector2.ONE
	fondo_b.scale = Vector2.ONE
	fondo_a.position = Vector2.ZERO
	fondo_b.position = Vector2(width, 0)

	self.set_process(true)

func _process(delta: float) -> void:
	offset += speed * delta
	offset = fmod(offset, float(width))

	var pos_x_base = -offset

	pos_x_base = float(int(round(pos_x_base)))


	fondo_a.position.x = pos_x_base
	fondo_b.position.x = pos_x_base + width
