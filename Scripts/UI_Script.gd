class_name Ui extends Control

var game : Game
var t_label : Label
var k_row : HBoxContainer

var key = preload("res://Scenes/ui_key.tscn")

@onready var init_size := size

var time : String
var key_count : int

func _ready(): 
	game = get_tree().current_scene
	
	game.ui = self
	t_label = $HUD/VBoxContainer/TimeLabel
	k_row = $HUD/HBoxContainer
	

func _process(delta): 
	t_label.text = str(time)
	
	scale = Vector2(get_viewport().size)/init_size
	
	if key_count > k_row.get_child_count(): for i in key_count - k_row.get_child_count(): k_row.add_child(key.instantiate())
	elif key_count < k_row.get_child_count(): for i in  k_row.get_child_count() - key_count: k_row.remove_child(k_row.get_child(get_child_count()-1))
