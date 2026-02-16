extends Area2D

@onready var ani: AnimatedSprite2D = $AnimatedSprite2D

@export var velocidad:=40.0
@export var target_position := Vector2(120, 10)
@export var tiempo:=50
const OVNI = preload("res://dialogos/ovni.dialogue")
var puede_click := false
func _ready() -> void:
	position = Vector2(-40, target_position.y)
	ani.play("volar")
	var tween := create_tween()
	tween.tween_property(self,'position',target_position,position.distance_to(target_position)/velocidad).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(_on_llegar)
	
func _on_llegar():
	ani.play("idle")
	puede_click=true
	await  get_tree().create_timer(tiempo).timeout
	_salir()
	

func  _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if not puede_click:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index==MOUSE_BUTTON_LEFT:
		print('hiciste click')
		DialogueManager.show_dialogue_balloon(OVNI)

func _salir():
	ani.play("volar")
	var salida:= Vector2(300,position.y)
	
	var tween:=create_tween()
	tween.tween_property(self,'position',salida,position.distance_to(salida)/velocidad).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(queue_free)
	
