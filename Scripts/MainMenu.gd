class_name MainMenu extends Control

var quick_tutorial = preload("res://Scenes/QuickTutorial.tscn")

@onready var game := get_tree().current_scene

func _on_press_start_button_down():	
	var tutorial = quick_tutorial.instantiate()
	get_parent().add_child(tutorial)
	game.quick_tutorial = tutorial
	game.music_player.stream = game.gameplay_theme
	game.main_menu = null
	queue_free()
