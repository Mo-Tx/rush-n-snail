class_name Collectable extends Area3D

@onready var init_pos = position
@onready var game = get_tree().current_scene

func _on_body_entered(body): if body.is_class("CharacterBody3D"): 
	body.collect()
	position = Vector3(randf_range(-10, 10), position.y, randf_range(-10, 10))

func _process(delta): position.y = init_pos.y + 0.1 * sin((Time.get_ticks_msec() / 1000.0)*5 * game.speed)
