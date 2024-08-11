class_name Game extends Node

@export var SETTINGS := {
	"GRAVITY" : ProjectSettings.get_setting("physics/3d/default_gravity"),
	"SPEED_MULTIPLIER" : 2.0
}

enum COLLECTABLES {KEY, LOCK}

var level : Node3D
var player : Player
var ui : Ui

var speed := 1

func _ready(): level = $World/Level

func _process(delta): 
	player.time
	ui.time = player.time
	ui.key_count = int(speed-1)
	$UI/HUD/VBoxContainer/Timer/AnimatedSprite2D.speed_scale = int(speed)
