extends Node2D

@onready var base: Sprite2D = $base
@onready var base_2: Sprite2D = $base2
@export var speed:=50

var width:=0
var offsite:=0.0

func _ready() -> void:
	width=int(base.texture.get_width())
	if width <=0:
		push_error('La textura del fondo no tiene ancho válido.')
		return
		
	base.scale=Vector2.ONE
	base_2.scale=Vector2.ONE
	base.position=Vector2.ZERO
	base_2.position=Vector2(width,0)
	
	self.set_process(true)
	
func  _process(delta: float) -> void:
	offsite+=delta*speed
	offsite=fmod(offsite,float(width))
	
	var pos_x_base=-offsite
	pos_x_base=float(int(round(pos_x_base)))
	
	base.position.x=pos_x_base
	base_2.position.x=pos_x_base+width
