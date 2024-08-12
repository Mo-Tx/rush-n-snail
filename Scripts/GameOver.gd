class_name GameOver extends Control

@onready var game := get_tree().current_scene
@onready var score_label = $MarginContainer/VBoxContainer/Label2

var score : int



func _ready(): score_label.text = "Score: " + str(score)


func _on_restart_pressed(): 
	
	game.start()	
	
	game.music_player.stream = game.gameplay_theme
