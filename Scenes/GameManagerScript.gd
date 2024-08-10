class_name Game extends Node

@export var SETTINGS := {
	"GRAVITY" : ProjectSettings.get_setting("physics/3d/default_gravity"),
	"SPEED_MULTIPLIER" : 2.0
}

var player : Player
var ui : Ui

var speed := 1

func _process(delta): 
	player.time
	ui.time = player.time
