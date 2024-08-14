class_name QuickTutorial extends Control

func _on_press_start_button_down(): accept()

func _input(event): if event.is_action_pressed("ui_accept"): accept()

func accept():  Game.start() 
