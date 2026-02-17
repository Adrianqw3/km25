extends Node2D

@onready var ave: CharacterBody2D = $CharacterBody2D
@export var speed: float = 60.0
@export var area_size: Vector2 = Vector2(256,144)

var targetposition: Vector2

func _ready() -> void:
	randomize()
	_set_new_target()

func _process(delta: float) -> void:
	var dir = (targetposition - ave.global_position).normalized()
	ave.global_position += dir * speed * delta
	
	if ave.global_position.distance_to(targetposition) < 10:
		_set_new_target()

func _set_new_target():
	var x = randf_range(0, area_size.x)
	var y = randf_range(0, area_size.y)
	targetposition = Vector2(x, y)
