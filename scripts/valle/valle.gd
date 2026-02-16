extends Node2D

@export var speed=40
@onready var valle: Sprite2D = $ValleFPrincipal
@onready var valle2: Sprite2D = $ValleFPrincipal2

var width:=0
var offsite:=0.0

func _ready() -> void:
	width=int(valle.texture.get_width())
	if width <=0:
		push_error('La textura del fondo no tiene ancho válido.')
		return
		
	valle.scale=Vector2.ONE
	valle2.scale=Vector2.ONE
	valle.position=Vector2.ZERO
	valle2.position=Vector2(width,0)
	
	self.set_process(true)
	
func  _process(delta: float) -> void:
	offsite+=delta*speed
	offsite=fmod(offsite,float(width))
	
	var pos_x_base=-offsite
	pos_x_base=float(int(round(pos_x_base)))
	
	valle.position.x=pos_x_base
	valle2.position.x=pos_x_base+width
