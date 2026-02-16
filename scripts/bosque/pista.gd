extends Node2D

@onready var pista1: Sprite2D = $PistaBosq2
@onready var pista2: Sprite2D = $PistaBosq
@export var speed :=45

var width :=0
var offset := 0.0

func _ready() -> void:
	width=int(pista1.texture.get_width())
	if width <=0:
		push_error('La textura del fondo no tiene ancho válido.')
		return
	
	pista1.scale=Vector2.ONE
	pista2.scale=Vector2.ONE
	pista1.position=Vector2.ZERO
	pista2.position=Vector2 (width,0)
	
	self.set_process(true)

func _process(delta: float) -> void:
	offset +=delta*speed
	offset=fmod(offset,float(width))
	
	var pos_x_base= -offset
	pos_x_base=float(int(round(pos_x_base)))
	
	pista1.position.x = pos_x_base
	pista2.position.x = pos_x_base + width
