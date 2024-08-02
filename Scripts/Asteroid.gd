extends Area2D

var speed = 333 
var rotation_speed = 0.0
var direction = Vector2()
var asteroid_skins = []

func _ready():
	set_process(true)
	connect("input_event", Callable(self, "_on_input_event"))
	
	# Random seed
	randomize()
	
	asteroid_skins = [
		{ "sprite": $Sprite2D1, "collision": $Collision1},
		{ "sprite": $Sprite2D2, "collision": $Collision2},
		{ "sprite": $Sprite2D3, "collision": $Collision3},
		{ "sprite": $Sprite2D4, "collision": $Collision4},
		{ "sprite": $Sprite2D5, "collision": $Collision5},
		{ "sprite": $Sprite2D6, "collision": $Collision6},
		{ "sprite": $Sprite2D7, "collision": $Collision7},
		{ "sprite": $Sprite2D8, "collision": $Collision8},
		{ "sprite": $Sprite2D9, "collision": $Collision9},
		{ "sprite": $Sprite2D10, "collision": $Collision10}
	]
	
	# Hide all skins 
	for skin in asteroid_skins:
		skin["sprite"].hide()
		skin["collision"].disabled = true
	
	# Randomly select one skin to show
	var selected_skin = asteroid_skins[randi() % asteroid_skins.size()]
	selected_skin["sprite"].show()
	selected_skin["collision"].disabled = false
	
	# Random spawn point and end point
	var start_y = randf_range(150, 900)
	position = Vector2(1024, start_y)	
	
	var end_y = randf_range(150, 900)
	var target_position = Vector2(0, end_y)

	direction = (target_position - position).normalized()
	
	rotation_speed = randf_range(-2.5, 2.5)

func _process(delta):
	position += direction * speed * delta
	rotation += rotation_speed * delta
	
	if position.x < -50:
		queue_free()
		get_parent().get_parent()._update_health(-1)


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			queue_free()
			get_parent().get_parent()._update_score(1)
