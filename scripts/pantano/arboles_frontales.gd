extends Node2D
@onready var arbol_frontal: Sprite2D = $arbol_frontal
@onready var arbol_frontal_2: Sprite2D = $arbol_frontal2
@export var speed:= 25

var width:=0
var offsite:=0.0

func _ready() -> void:
	width=int(arbol_frontal.texture.get_width())
	if width <=0:
		push_error('La textura del fondo no tiene ancho válido.')
		return
		
	arbol_frontal.scale=Vector2.ONE
	arbol_frontal_2.scale=Vector2.ONE
	arbol_frontal.position=Vector2.ZERO
	arbol_frontal_2.position=Vector2(width,0)
	
	self.set_process(true)
	
func  _process(delta: float) -> void:
	offsite+=delta*speed
	offsite=fmod(offsite,float(width))
	
	var pos_x_base=-offsite
	pos_x_base=float(int(round(pos_x_base)))
	
	arbol_frontal.position.x=pos_x_base
	arbol_frontal_2.position.x=pos_x_base+width
