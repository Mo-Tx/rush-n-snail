class_name Collectable extends Area3D

# script used for collectables generally(keys locks, c-locks(nice pun btw lol) etc...); the behaviour is managed in the player script and collectible tags are found in the Game(Manager) script

var init_pos : Vector3

var game : Game

@export var TYPE : Game.COLLECTABLES # obvious enough

func _ready(): 
	init_pos = position
	game = get_tree().current_scene
	
	if TYPE != Game.COLLECTABLES.KEY: position = Vector3(randf_range(-25, 25), position.y, randf_range(-25, 25))

func _on_body_entered(body): if body.is_class("CharacterBody3D"): # might look wierd but just done to save space, anyway it checks if the collectible has actually collided with the player before calling a method that doesn't exist on that node
	body.collect(TYPE) # now safetly call the function since we know it is indeed the player
	if TYPE == Game.COLLECTABLES.KEY:  queue_free() # if it's a key disapper since frogs are always making those
	else: position = Vector3(randf_range(-75, 75), position.y, randf_range(-75, 75)) # TBD: make them spawn randomly instead of doing this
	
func _process(_delta): position.y = init_pos.y + 0.1 * sin((Time.get_ticks_msec() / 1000.0)*5 * game.speed) # floating behaviour based on a sine wave
