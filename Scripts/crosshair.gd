extends Area2D

@onready var laser_sound = $LaserSound
@onready var cross_sprite = $CrossSprite

func _ready():
	set_process(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	cross_sprite.play("Idle")

func _process(_delta):
	global_position = get_viewport().get_mouse_position()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			laser_sound.play()
			cross_sprite.play("cross")
		else:
			cross_sprite.play("Idle")
