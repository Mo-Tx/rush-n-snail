extends Control

var quicktutorial = preload("res://Scenes/QuickTutorial.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	


func _on_press_start_button_down():
	
	get_tree().change_scene_to_packed(quicktutorial)
