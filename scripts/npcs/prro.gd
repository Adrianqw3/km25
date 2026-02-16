extends Area2D

@onready var anima: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

const PERRO_DIALOGO := preload("res://dialogos/perro.dialogue")

@export var velocidad: float = 20.0

var puede_click := false
var target_position: Vector2

func _ready() -> void:
	input_pickable = true
	collision_shape.disabled = false

	anima.play("caminar")

	position = Vector2(-16, position.y)

	target_position = Vector2(100, position.y)

	var tween := create_tween()
	tween.tween_property(
		self,
		"position",
		target_position,
		position.distance_to(target_position) / velocidad
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.finished.connect(_on_llegar)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	
func _on_dialogue_ended(_resource):
	if EstadosNpc.npcs.perro.iniciada==true:
		desaparecer()

func _on_llegar() -> void:
	anima.play("idle")
	puede_click = true

func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not puede_click:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print(" Click al perro")
		DialogueManager.show_dialogue_balloon(PERRO_DIALOGO)
		
func desaparecer()->void:
	puede_click = false
	
	var tween:= create_tween()
	tween.tween_property(self,'modulate:a',0.0,0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.finished.connect(queue_free)	
	
