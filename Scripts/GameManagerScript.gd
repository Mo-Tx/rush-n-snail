class_name Game extends Node

# the script for the Game root node/class used to managed the game and communicate far-away relative nodes with each other

@export var SETTINGS := { # the settings of the game, exported for modularity
	"SPEED_MULTIPLIER" : 2.5,
	"FRUIT_COUNT": 15,
	"LOCK_COUNT": 5,
	"TIMER_COUNT": 1
}

enum COLLECTABLES {KEY, LOCK, TIMER, FRUIT} # every collectable type for tagging so the player script can differenciate between the types

# main compoments of the game
var level : Node3D
var world : WorldEnvironment
var player : Player
var ui : Ui
var music_player : AudioStreamPlayer
var hud : Control
var main_menu : Control
var quick_tutorial : Control
var game_over : Control

var fruit := preload("res://Scenes/fruit.tscn")
var lock := preload("res://Scenes/lock.tscn")
var timer := preload("res://Scenes/timer.tscn")
var level_scene := preload("res://Scenes/level.tscn")
var hud_scene := preload("res://Scenes/hud.tscn")
var main_menu_scene := preload("res://Scenes/MainMenu.tscn")
var quick_tutorial_scene := preload("res://Scenes/QuickTutorial.tscn")
var game_over_scene := preload("res://Scenes/game_over.tscn")
var main_theme := preload("res://Songs/Main Theme.mp3")
var gameplay_theme := preload("res://Songs/Gameplay Theme.mp3")

var time := 0.0
var speed := 1 # the dynamic speed value of the game if you didn't know it
var ended := true
var paused := false

func _ready():
	world = $World
	ui = $UI
	music_player = $AudioStreamPlayer
	main_menu = main_menu_scene.instantiate()
	ui.add_child(main_menu)
	
func _process(delta): 
	music_player.pitch_scale = speed/2.0 + 0.5
	if !music_player.playing: music_player.play()
	if !(ended || paused):
		time += delta
		ui.time = player.time # most obviously obvious line in the entire game
		ui.food = str(player.food) # same thing lol
		ui.key_count = int(speed-1) # too lazy to write int(round()) so i just wrote int directly because godot automatically handles that lol; anyway this just changes the amount of keys based on the game speed so the game doesn't have to keep asking the player for how many keys they collected, and the UI uses that to display how many keys you have, if you didn't like it then i don't care it's not your code lol; btw just wanted to say this is the longest line of comment i've ever written XD 
		RenderingServer.global_shader_parameter_set_override("game_speed", 1.0)

func start():
	level = level_scene.instantiate()
	hud = hud_scene.instantiate()
	world.add_child(level)
	ui.add_child(hud)
	if quick_tutorial: ui.remove_child(quick_tutorial)
	if game_over:ui.remove_child(game_over)
	quick_tutorial = null
	game_over = null
	
	player.food = 0
	
	for i in SETTINGS["FRUIT_COUNT"]: level.add_child(fruit.instantiate())
	for i in SETTINGS["LOCK_COUNT"]: level.add_child(lock.instantiate())
	for i in SETTINGS["TIMER_COUNT"]: level.add_child(timer.instantiate())

	ended = false
	# add other things if needed 

func end(score):
	world.remove_child(level)
	ui.remove_child(hud)
	level = null
	hud = null
	
	music_player.stream = main_theme
	
	ended = true
	speed = 1
	
	game_over = game_over_scene.instantiate()
	game_over.score = score
	ui.add_child(game_over)
	# add behaviour for game over screen or anything else here
