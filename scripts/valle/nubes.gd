extends Node2D

@export var speed=20
@onready var fondo2: Sprite2D = $ValleFSecundario2
@onready var fondo: Sprite2D = $ValleFSecundario

var width :=0
var offsite:=0.0


func  _ready() -> void:
	width=int(fondo.texture.get_width())
	if width <=0:
		push_error("La textura del fondo no tiene ancho válido.")
		return
	
	fondo.scale=Vector2.ONE
	fondo2.scale=Vector2.ONE
	fondo.position=Vector2.ZERO
	fondo2.position=Vector2(width,0)

	self.set_process(true)
	
func _process(delta: float) -> void:
	offsite+=delta*speed
	offsite=fmod(offsite,float(width))
	
	var pos_x_base = -offsite
	pos_x_base=float(int(round(pos_x_base)))
	
	fondo.position.x = pos_x_base
	fondo2.position.x = pos_x_base + width
