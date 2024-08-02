extends Area2D

var speed = 250
var direction = Vector2()

func _ready():
	set_process(true)
	connect("input_event", Callable(self, "_on_input_event"))
	
	randomize()

	# Random spawn point and end point
	var start_y = randf_range(200, 1000)
	position = Vector2(1024, start_y)
	
	var end_y = randf_range(200, 1000)
	var target_position = Vector2(0, end_y)

	direction = (target_position - position).normalized()

func _process(delta):
	position += direction * speed * delta
	
	if position.x < -64:
		queue_free()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			queue_free()
			get_parent().get_parent()._update_health(1)
