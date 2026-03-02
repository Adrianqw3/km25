extends Node2D
@onready var arbol_sec_1: Sprite2D = $arbol_sec1
@onready var arbol_sec_2: Sprite2D = $arbol_sec2
@export var speed:=45

var width:=0
var offsite:=0.0

func _ready() -> void:
	width=int(arbol_sec_1.texture.get_width())
	if width <=0:
		push_error('La textura del fondo no tiene ancho válido.')
		return
		
	arbol_sec_1.scale=Vector2.ONE
	arbol_sec_2.scale=Vector2.ONE
	arbol_sec_1.position=Vector2.ZERO
	arbol_sec_2.position=Vector2(width,0)
	
	self.set_process(true)
	
func  _process(delta: float) -> void:
	offsite+=delta*speed
	offsite=fmod(offsite,float(width))
	
	var pos_x_base=-offsite
	pos_x_base=float(int(round(pos_x_base)))
	
	arbol_sec_1.position.x=pos_x_base
	arbol_sec_2.position.x=pos_x_base+width
