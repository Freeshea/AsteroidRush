extends HSlider

@export
var bus_name : String
var bus_index : int

# Called when the node enters the scene tree for the first time.
func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	
	# Gets value from db slider to globally set volume (future iteration)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(value):
	# linear_to_db to ensure the audio control is more practical and intuitive for human perception
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))
