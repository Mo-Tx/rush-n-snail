class_name Ui extends Control

# HUD components
var t_label : Label # time label (counter)
var f_label : Label
var k_row : HBoxContainer # key row
var clock : AnimatedSprite2D # timer clock

var key = preload("res://Scenes/ui_key.tscn") # the HUD key scene

@onready var init_size := size # initial size for scaling

var time : String
var food : String
var key_count : int

func _process(_delta): 
	if Game.state == Game.STATE.PLAYING: #HUD handling
		var hud_key_count = k_row.get_child_count()
		
		if !clock.is_playing(): clock.play()
		if Game.player && clock.speed_scale == 0: clock.speed_scale = 1.0 #prevent the player's timer and the clock from desyncing by making them both start at the same time
		if clock.speed_scale != 0: clock.speed_scale = int(Game.speed) # change the animation speed of the clock based on the Game speed provided by the Game
		
		t_label.text = time # update the counter based on the time left provided by the Game
		f_label.text = food
	
		if key_count > hud_key_count: for i in key_count - hud_key_count: k_row.add_child(key.instantiate()) # add the needed amount of keys to match the key count provided by the Game if they don't match
		elif key_count < hud_key_count: for i in  hud_key_count - key_count: k_row.remove_child(k_row.get_child(hud_key_count-1)) # the opposite of the last comment
	elif Game.state == Game.STATE.PAUSED: clock.pause()


func update(): #called by the Game when the HUD is ready
		t_label = $HUD/Timer/TimeLabel
		f_label = $HUD/Fruits/FoodLabel
		k_row = $HUD/KeyRow
		clock = $HUD/Timer/Clock/AnimatedSprite2D
