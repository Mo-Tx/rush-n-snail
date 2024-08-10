class_name Ui extends Control

var game : Game
var t_label : Label

var time : String

func _ready(): 
	game = get_tree().current_scene
	game.ui = self
	t_label = $HUD/TimeLabel

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta): t_label.text = str(time)
