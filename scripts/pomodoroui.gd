extends Control

@onready var bar: TextureProgressBar = $TextureProgressBar
@onready var cycles := $HBoxContainer.get_children()

func _ready():
	bar.min_value = 0.0
	bar.max_value = 1.0
	bar.value = 0.0

	for c in cycles:
		c.modulate = Color(1, 1, 1, 0.25)

func _process(delta):
	if MainScript.time_total <= 0:
		bar.value = 0
		return
	bar.value = 1.0 - (MainScript.time_left / MainScript.time_total)
	bar.value = clamp(bar.value, 0.0, 1.0)

	if MainScript.is_working:
		bar.tint_progress = Color(0.6, 0.7, 1.0, 0.85)
	else:
		if MainScript.time_total == MainScript.long_break_duration:
			bar.tint_progress = Color(1.0, 0.8, 0.4, 0.85)
		else:
			bar.tint_progress = Color(0.6, 1.0, 0.7, 0.85)

	var active_cycles := MainScript.cycles_completed % 4
	for i in cycles.size():
		if i < active_cycles:
			cycles[i].modulate = Color(1, 1, 1, 0.9)
		else:
			cycles[i].modulate = Color(1, 1, 1, 0.25)
