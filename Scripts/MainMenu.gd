class_name MainMenu extends Control

@onready var quick_tutorial := Game.quick_tutorial_scene # to avoid loading the same thing twice for performence reasons

func _on_press_start_button_down():	accept()

func _input(event): if event.is_action_pressed("ui_accept"): accept()
	
func accept():
	var tutorial = quick_tutorial.instantiate()
	get_parent().add_child(tutorial)
	Game.quick_tutorial = tutorial
	Game.music_player.stream = Game.Gameplay_theme
	Game.main_menu = null
	queue_free()
