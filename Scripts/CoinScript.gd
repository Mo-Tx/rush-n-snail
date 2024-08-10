class_name Coin extends Area3D

func _on_body_entered(body): if body.is_class("CharacterBody3D"): 
	body.collect()
	position = Vector3(randf_range(-10, 10), position.y, randf_range(-10, 10))
