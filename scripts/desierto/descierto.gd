extends Node2D
 

@export var speed:=45
@onready var desierto_f: Sprite2D = $DesiertoF
@onready var desierto_f_2: Sprite2D = $DesiertoF2

var width:=0
var offset:=0.0

func _ready() -> void:
	width=desierto_f.texture.get_width()
	if width<=0:
		push_error('La textura del fondo no tiene ancho válido.')
		return
		
	desierto_f.scale=Vector2.ONE
	desierto_f_2.scale=Vector2.ONE
	desierto_f.position=Vector2.ZERO
	desierto_f_2.position=Vector2(width,0)
	
	self.set_process(true)
	
func _process(delta: float) -> void:
	offset+=delta*speed
	offset=fmod(offset,float(width))
	
	var pos_x_base = -offset
	pos_x_base=float(int(round(pos_x_base)))
	
	desierto_f.position.x=pos_x_base
	desierto_f_2.position.x=pos_x_base+width
