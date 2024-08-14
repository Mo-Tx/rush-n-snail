class_name Camera extends Camera3D

@onready var OFFSET := position # make the offset the same as the initial positio in the scene so i don't have to keep editing 2 vectors

func _process(_delta): if Game.state == Game.STATE.PLAYING: position = Game.player.position + OFFSET # literally just follows around the player with the previously described offset
