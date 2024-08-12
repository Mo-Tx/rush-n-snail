class_name QuickTutorial extends Control

@onready var game := get_tree().current_scene

func _on_press_start_button_down(): game.start() 
