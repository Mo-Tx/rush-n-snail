class_name Collectable extends Area3D

@onready var init_pos = position
@onready var game = get_tree().current_scene

@export var TYPE : Game.COLLECTABLES

func _on_body_entered(body): if body.is_class("CharacterBody3D"): 
	body.collect(TYPE)
	if TYPE == Game.COLLECTABLES.KEY:  queue_free()
	else: position = Vector3(randf_range(-50, 50), position.y, randf_range(-50, 50))
	
func _process(delta): position.y = init_pos.y + 0.1 * sin((Time.get_ticks_msec() / 1000.0)*5 * game.speed)
