class_name Ui extends Control

# HUD components
var game : Game
var t_label : Label # time label (counter)
var f_label : Label
var k_row : HBoxContainer # key row
var clock : AnimatedSprite2D # timer clock

var key = preload("res://Scenes/ui_key.tscn") # the HUD key scene

@onready var init_size := size # initial size for scaling

var time : String
var food : String
var key_count : int

func _ready(): game = get_tree().current_scene


func _process(_delta): 
	if !(game.ended || game.paused):
		t_label = $HUD/Timer/TimeLabel
		f_label = $HUD/Fruits/FoodLabel
		k_row = $HUD/KeyRow
		clock = $HUD/Timer/Clock/AnimatedSprite2D
		
		var hud_key_count = k_row.get_child_count()
		
		t_label.text = time # update the counter based on the time left provided by the game
		f_label.text = food
		clock.speed_scale = int(game.speed) # change the animation speed of the clock based on the game speed provided by the game
	
		if key_count > hud_key_count: for i in key_count - hud_key_count: k_row.add_child(key.instantiate()) # add the needed amount of keys to match the key count provided by the game if they don't match
		elif key_count < hud_key_count: for i in  hud_key_count - key_count: k_row.remove_child(k_row.get_child(hud_key_count-1)) # the opposite of the last comment
