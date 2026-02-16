extends Node2D

@export var speed:=30
@onready var desierto: Sprite2D = $Desierto
@onready var desierto_2: Sprite2D = $Desierto2

var width:=0
var offset:=0.0

func _ready() -> void:
	width=desierto.texture.get_width()
	if width <=0:
		push_error('La textura del fondo no tiene ancho válido.')
		return
		
	desierto.scale=Vector2.ONE
	desierto_2.scale=Vector2.ONE
	desierto.position=Vector2.ZERO
	desierto_2.position=Vector2(width,0)
	
	self.set_process(true)
	
func _process(delta: float) -> void:
	offset+=delta*speed
	offset=fmod(offset,float(width))
	
	var pos_x_base = -offset
	pos_x_base=float(int(round(pos_x_base)))
	
	desierto.position.x=pos_x_base
	desierto_2.position.x=pos_x_base+width
