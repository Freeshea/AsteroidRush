extends Node2D

var score = 0
var health = 5
var spawn_rate = 1.0 # */sec
var asteroid_timer : Timer
var spawn_rate_tracker_timer : Timer
var health_up_tracker : Timer
var time_interval = 15.0 # sec
var health_up_time_interval = 30.0 # sec

@onready var game_over_control = $GameOverControl
@onready var pause_menu = $PauseMenu

@onready var health_up_sound = $HealthUp
@onready var health_down = $HealthDown
@onready var destroyed_sound = $DestroyedSound
@onready var game_over = $GameOver

func _ready():
	$Score_label.text = "Score: " + str(score)
	$Health_label.text = "Health: " + str(health)
	
	# Spawn asteroids
	asteroid_timer = Timer.new()
	add_child(asteroid_timer)
	asteroid_timer.connect("timeout", Callable(self, "_on_spawn_asteroid"))
	asteroid_timer.start(spawn_rate)  
	
	 # Spawn rate increase
	spawn_rate_tracker_timer = Timer.new()
	add_child(spawn_rate_tracker_timer)
	spawn_rate_tracker_timer.connect("timeout", Callable(self, "_on_time_interval"))
	spawn_rate_tracker_timer.start(time_interval)
	
	# Health up object spawner
	health_up_tracker = Timer.new()
	add_child(health_up_tracker)
	health_up_tracker.connect("timeout", Callable(self, "_on_spawn_health_up"))
	health_up_tracker.start(health_up_time_interval)
	
func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause_menu.visible = true
		get_tree().paused = true

# Spawn asteroid instance func
func _on_spawn_asteroid():
	var asteroid_scene = preload("res://Scenes/Asteroid.tscn")
	var asteroid = asteroid_scene.instantiate()
	$Asteroids.add_child(asteroid)

# Spawn health up instance func
func _on_spawn_health_up():
	var health_up_scene = preload("res://Scenes/health_up.tscn")
	var health_up = health_up_scene.instantiate()
	$HealthUps.add_child(health_up)
	health_up_tracker.start(health_up_time_interval)
	
func _on_time_interval():
	_increase_spawn_rate()
	spawn_rate_tracker_timer.start(time_interval)

func _update_score(points):
	destroyed_sound.play()
	score += points
	$Score_label.text = "Score: %d" % score

func _increase_spawn_rate():
	# Decrease the spawn rate to increase spawn frequency
	spawn_rate = max(0.1, spawn_rate * 0.9)
	asteroid_timer.start(spawn_rate)

func _update_health(value):
	if value >=0 :
		health_up_sound.play()
	else:
		health_down.play()
	health += value
	$Health_label.text = "Health: %d" % health
	if health <= 0:
		_game_over()

func _game_over():
	game_over.play()
	$Crosshair.get_node("LaserSound").stream = null
	get_tree().paused = true
	game_over_control.visible = true

func _restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _quit_button_pressed():
	get_tree().quit()

func _on_resume_button_pressed():
	get_tree().paused = false
	pause_menu.visible = false
