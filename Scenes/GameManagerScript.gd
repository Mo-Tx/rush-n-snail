class_name Game extends Node

var SETTINGS := {
	"GRAVITY" : ProjectSettings.get_setting("physics/3d/default_gravity")
}

var player : Player
var ui : Ui

var speed := 1

func _process(delta): 
	player.time
	ui.time = player.time
	
