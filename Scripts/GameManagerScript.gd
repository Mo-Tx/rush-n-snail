class_name Game extends Node

# the script for the Game root node/class used to managed the Game and communicate far-away relative nodes with each other

const SETTINGS := { # the settings of the Game, exported for modularity
	"SPEED_MULTIPLIER": 2.5,
	"MAP_SIZE": 30,
	"START_TIME": 5.00, # integer part is the minutes, decimal part is the seconds
	"FRUIT_COUNT": 20,
	"LOCK_COUNT": 10,
	"TIMER_COUNT": 1,
	"FROG_COUNT": 3
}

enum COLLECTABLES {KEY, LOCK, TIMER, FRUIT} # every collectable type for tagging so the player script can differenciate between the types
enum STATE {PLAYING, ENDED, PAUSED} # possible game states to avoid crashed and/or unexpected behaviour

# main compoments of the Game
static var world : WorldEnvironment
static var player : Player
static var ui : Ui
static var music_player : AudioStreamPlayer
static var level : Node3D
static var hud : Control
static var main_menu : Control
static var quick_tutorial : Control
static var game_over : Control

static var fruit := preload("res://Scenes/fruit.tscn")
static var key := preload("res://Scenes/key.tscn")
static var lock := preload("res://Scenes/lock.tscn")
static var timer := preload("res://Scenes/timer.tscn")
static var frog := preload("res://Scenes/frog.tscn")
static var level_scene := preload("res://Scenes/level.tscn")
static var hud_scene := preload("res://Scenes/hud.tscn")
static var main_menu_scene := preload("res://Scenes/MainMenu.tscn")
static var quick_tutorial_scene := preload("res://Scenes/QuickTutorial.tscn")
static var game_over_scene := preload("res://Scenes/game_over.tscn")
static var main_theme := preload("res://Songs/Main Theme.mp3")
static var Gameplay_theme := preload("res://Songs/Gameplay Theme.mp3")

static var time := 0.0
static var speed := 1 # the dynamic speed value of the game if you didn't know it
static var state := STATE.ENDED

func _ready():
	world = $World
	ui = $UI
	music_player = $AudioStreamPlayer
	main_menu = main_menu_scene.instantiate()
	ui.add_child(main_menu)
	
func _process(delta): 
	#pause handling
	if Input.is_action_just_released("ui_cancel"): match state: # made it not look like a nest even though it is lol, anyway this would toggle pausing unless if you are in the main menu or mage over menu
		STATE.PLAYING: state = STATE.PAUSED
		STATE.PAUSED: state = STATE.PLAYING
	
	# music handling
	music_player.pitch_scale = speed/2.0 + 0.5
	if !music_player.playing: music_player.play()
	
	# main game managment
	if state == STATE.PLAYING:
		time += delta
		ui.time = player.time # most obviously obvious line in the entire game
		ui.food = str(player.food) # same thing lol
		ui.key_count = int(speed-1) # too lazy to write int(round()) so i just wrote int directly because godot automatically handles that lol; anyway this just changes the amount of keys based on the game speed so the game doesn't have to keep asking the player for how many keys they collected, and the UI uses that to display how many keys you have, if you didn't like it then i don't care it's not your code lol; btw just wanted to say this is the longest line of comment i've ever written XD 
		#RenderingServer.global_shader_parameter_set_override("game_speed", 1.0)

static func start():
	# add the gameplay-related scenes
	level = level_scene.instantiate()
	hud = hud_scene.instantiate()
	world.add_child(level)
	ui.add_child(hud)
	# remove the unnecessary ones
	if quick_tutorial: quick_tutorial.queue_free()
	if game_over: game_over.queue_free()
	quick_tutorial = null
	game_over = null
	# update the ui so it knows the game has started
	ui.update()
	
	# reset player food/score count
	player.food = 0
	
	# spawn all collectables based on their specified count
	for i in SETTINGS.FRUIT_COUNT: level.add_child(fruit.instantiate())
	for i in SETTINGS.LOCK_COUNT: level.add_child(lock.instantiate())
	for i in SETTINGS.TIMER_COUNT: level.add_child(timer.instantiate())
	for i in SETTINGS.FROG_COUNT: level.add_child(frog.instantiate())

	# change the stare
	state = STATE.PLAYING
	# add other things if needed 

static func end(score):
	# romove the gameplay-related nodes to avoid unexpected behaviour
	level.queue_free()
	hud.queue_free()
	level = null
	hud = null
	
	# change the music
	music_player.stream = main_theme
	
	# change the state
	state = STATE.ENDED
	
	# reset the speed to avoid annoying music and crashes
	speed = 1
	
	# add the game over scene and adjust its score counter because, well, the game has ended if you run this, this is basically a instant_lose function
	game_over = game_over_scene.instantiate()
	game_over.score = score
	ui.add_child(game_over)
	# add behaviour for anything else here
