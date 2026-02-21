extends Node2D

@onready var ave: CharacterBody2D = $CharacterBody2D
@onready var collider: CollisionShape2D = $CharacterBody2D/CollisionShape2D

@export var speed: float = 60.0
@export var area_size: Vector2 = Vector2(256,144)
@export var suavizado: float = 3.0

var targetposition: Vector2
var velocity := Vector2.ZERO

func _ready() -> void:
	randomize()
	_set_new_target()

func _physics_process(delta: float) -> void:
	var dir = (targetposition - ave.global_position).normalized()
	velocity = velocity.lerp(dir * speed, suavizado * delta)
	ave.global_position += velocity * delta
	
	if ave.global_position.distance_to(targetposition) < 10:
		_set_new_target()

func _set_new_target():
	var x = randf_range(0, area_size.x)
	var y = randf_range(0, area_size.y)
	targetposition = Vector2(x, y)

func _input(event):
	if event is InputEventMouseButton \
	and event.pressed \
	and event.button_index == MOUSE_BUTTON_LEFT:
		
		if _mouse_sobre_ave():
			queue_free()

func _mouse_sobre_ave() -> bool:
	var mouse_pos = get_global_mouse_position()
	var shape = collider.shape
	
	if shape is CircleShape2D:
		var center = ave.global_position + collider.position
		return mouse_pos.distance_to(center) <= shape.radius
	
	if shape is RectangleShape2D:
		var rect_pos = ave.global_position + collider.position - shape.size/2
		var rect = Rect2(rect_pos, shape.size)
		return rect.has_point(mouse_pos)
	
	return false
