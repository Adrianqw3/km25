extends Node2D

@onready var pantano_fondo_1: Sprite2D = $PantanoFondo1
@onready var pantano_fondo_2: Sprite2D = $PantanoFondo2
@export var speed:= 30

var width:=0
var offsite:=0.0

func _ready() -> void:
	width=int(pantano_fondo_1.texture.get_width())
	if width <=0:
		push_error('La textura del fondo no tiene ancho válido.')
		return
		
	pantano_fondo_1.scale=Vector2.ONE
	pantano_fondo_2.scale=Vector2.ONE
	pantano_fondo_1.position=Vector2.ZERO
	pantano_fondo_2.position=Vector2(width,0)
	
	self.set_process(true)
	
func  _process(delta: float) -> void:
	offsite+=delta*speed
	offsite=fmod(offsite,float(width))
	
	var pos_x_base=-offsite
	pos_x_base=float(int(round(pos_x_base)))
	
	pantano_fondo_1.position.x=pos_x_base
	pantano_fondo_2.position.x=pos_x_base+width
