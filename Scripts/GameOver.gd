class_name GameOver extends Control

@onready var score_label = $MarginContainer/VBoxContainer/Label2

var score : int

func _ready(): score_label.text = "Score: " + str(score)

func _on_restart_pressed(): accept()

func _input(event): if event.is_action_pressed("ui_accept") && event.acti: accept()
	
func accept(): 
	Game.start()	
	Game.music_player.stream = Game.Gameplay_theme
