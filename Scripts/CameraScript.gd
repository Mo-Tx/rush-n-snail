class_name Camera extends Camera3D

var game : Game

@onready var OFFSET := position

func _ready(): game = get_tree().current_scene

func _process(delta): position = game.player.position + OFFSET
