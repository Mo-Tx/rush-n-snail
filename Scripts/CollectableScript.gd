class_name Collectable extends Area3D

# script used for collectables generally(keys locks, c-locks(nice pun btw lol) etc...); the behaviour is managed in the player script and collectible tags are found in the Game(Manager) script

@onready var limit := Game.SETTINGS.MAP_SIZE

var init_pos : Vector3

# stats
@export var type : Game.COLLECTABLES
@export var lifetime : float ## set to 0 for infinite lifetime

# tween-related variables
var tween : Tween
var tween_direction : float # angle not vector
var tween_distance : float
var tween_duration : float

@onready var SE := $AudioStreamPlayer3D

func _ready(): 
	# set the initial position
	init_pos = position
	
	tween = create_tween()
	tween.stop()
	
	# if this isn't a key make it spawn at a random position
	if type != Game.COLLECTABLES.KEY: position = Vector3(randf_range(-limit, limit), position.y, randf_range(-limit, limit))
	#setup timer if a lifetime has been specified
	if lifetime != 0: setup_timer()
	
# updates the values of the tween, used right before playing it
func update_tween():
	# kill the old tween to avoid memory leaks
	if tween != null: tween.kill()
	# create the new tween and prevent it from autostarting
	tween = create_tween()
	tween.stop()
	# add the tween properties
	tween.tween_property(self, "position", Vector3(position.x+sin(tween_direction)*tween_distance, position.y, position.z+cos(tween_direction)*tween_distance), tween_duration/tween_distance/Game.speed).set_ease(Tween.EASE_OUT)
	
func setup_timer():
	var timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	timer.start(lifetime)
	
func _process(_delta): position.y = init_pos.y + 0.1 * sin((Time.get_ticks_msec() / 1000.0)*5 * Game.speed) # floating behaviour based on a sine wave

# throwing behaviour currently used by both the player and the frog
func throw(direction, distance, duration):
	# setup the values for the tween
	tween_direction = direction
	tween_distance = distance
	tween_duration = (duration*distance)/Game.speed
	# update the tween before playing
	update_tween()
	# now play the tween
	tween.play()
	
func despawn():
	if type == Game.COLLECTABLES.KEY || lifetime != 0:  queue_free() # if it's a key disapper since frogs are always making those
	else: position = Vector3(randf_range(-limit, limit), position.y, randf_range(-limit, limit))
	visible = true

# signals

func _on_body_entered(body): 
	if !SE.playing: if body.is_class("CharacterBody3D"): if !tween.is_running() || type != Game.COLLECTABLES.FRUIT: # big boy 1-line nest :O
		SE.pitch_scale = Game.speed/2.0 + 0.5
		SE.play()
		body.collect(type) # now safetly call the function since we know it is indeed the player
		if type == Game.COLLECTABLES.FRUIT: # if it's a key, skip the extra steps with an early(well nor really second to last line) return since fruits don't have a SE so the signal won't get triggered, otherwise just turn invisible and wait for the signal to end to turn once again visible
			despawn()
			return
		visible = false
	else: return
	
func _on_audio_stream_player_3d_finished():	despawn()

func _on_timer_timeout(): queue_free()
