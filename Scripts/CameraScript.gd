class_name Camera extends Camera3D

@onready var game := get_tree().current_scene # since i already did onready for the next line there's no point for defining this in the ready function like i did for the other if it's gonna be the only thing there 

@onready var OFFSET := position # make the offset the same as the initial positio in the scene so i don't have to keep editing 2 vectors


func _process(_delta): if !(game.ended || game.paused): position = game.player.position + OFFSET # literally just follows around the player with the previously described offset
