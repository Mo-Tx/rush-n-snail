class_name Frog extends Area3D

enum STATE {IDLE, JUMPING, SPITTING}

@export var detection_range := 15
@export var jump_height := 2

# node references
var tween : Tween # hop tween
var anim : AnimationPlayer
var j_timer : Timer # jump timer for cooldown
var s_timer : Timer # spit timer, for cooldown too

# declare and set the default stats
var can_jump := true
var can_spit := false
var state := STATE.IDLE

# tween_related references
var hop_target : Vector3
var hop_height : float
var hop_duration : float
var spit_distance : float
var spit_duration : float
var spit_key_ins : Collectable

@onready var SE := $AudioStreamPlayer3D

@onready var limit = Game.SETTINGS.MAP_SIZE # to save space

@onready var key_scene := Game.key # done for performence reasons so multiple instances won't load the same thing for each and instead use a shared scene

# setup, should be obvious enough
func _ready():
	position = Vector3(randf_range(-limit, limit), position.y, randf_range(-limit, limit))
	# do i even have to explain?
	randomize()
	# create tween references to avoid crashing
	tween = create_tween()
	# other references
	j_timer = $JumpTimer
	s_timer = $SpitTimer
	anim = $Model/AnimationPlayer
	
# updates the values of the tween, used right before playing it
func update_tween():
	# kill the old tween to avoid memory leaks
	tween.kill()
	# create the new tween and prevent it from autostarting
	tween = create_tween()
	tween.stop()
	# add the tween properties
	tween.tween_property(self, "position", Vector3((position.x+hop_target.x)/2, hop_height, (position.z+hop_target.z)/2), hop_duration/2).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", hop_target, hop_duration/2).set_ease(Tween.EASE_IN)
	
	
#frog main behaviour loop
func _process(_delta): if Game.state == Game.STATE.PLAYING: if tween.finished && anim.current_animation != "Frog_Spit" && anim.current_animation != "Frog_Idle":  # check if no animations/tweens other than idle are playing before doing the state machine (yes finally not spaghetti machine i finally bothered to fix it
	# state managmet
	if can_jump: state = STATE.JUMPING # jumping, first priority if the cooldown has ended
	elif can_spit: state = STATE.SPITTING
	elif !anim.is_playing(): state = STATE.IDLE# if no cooldowns are up then wait for all animations to end then idle
	# behaviour managment based on state
	match state:
		STATE.IDLE: anim.play("Frog_Idle", -1, Game.speed) # play idle animation and do nothing else if the state is idle
		STATE.JUMPING: jump()
		STATE.SPITTING: spit()
		
	
# frog behaviours	

func jump(): # chose a targrt to jump to then hop to it
	# player position to save the hassle of writing all of that so much, that's why it's exclusive to the scope
	var p_pos = Game.player.position 
	# jump to the player if close enough
	if position.distance_to(p_pos) <= detection_range: hop(p_pos, jump_height, position.distance_to(p_pos)/(Game.speed*10)) 
	# jump to a random position nearby if not so the frog doesn't just idle and keep spitting keys making them all cluttered up
	else:
		var r_pos = position + Vector3(randf_range(-detection_range, detection_range),0, randf_range(-detection_range, detection_range)) # random nearby position
		# if the random position goes too far then redo another one so the frog doesnt cross the Game border magically lol
		if abs(r_pos.x) > limit || abs(r_pos.z) > limit : r_pos = position + Vector3(randf_range(-detection_range, detection_range),0, randf_range(-detection_range, detection_range)) 
		else: hop(r_pos, jump_height, position.distance_to(r_pos)/(Game.speed*7))
	
# behaviour for spitting a key
func spit():
	# temporary variables
	var key = key_scene.instantiate()
	var power = randf_range(0, 5)
	# add the key to the level before doing anything to it to avoid unexpected behaviour
	Game.level.add_child(key)
	# rotate to a random angle
	rotation.y = randf_range(-180, 180)
	# make key match the frog's position exept the vertical one so it doesn't fly on accident
	key.position.x = position.x
	key.position.z = position.z
	
	SE.pitch_scale = Game.speed/2.0 + 0.5
	SE.play()
	# play spit animation
	anim.play("Frog_Spit", -1, power*Game.speed + 1)
	# throw the key
	key.throw(rotation.y, power, 1)
	# update the boolean
	can_spit = false
	
func hop(target, height, duration): # hopping animation and some cooldown behaviour
	# stop all animations and the spit timer to avoid overlapping
	anim.stop()
	s_timer.stop()
	#set the rotation to make it look at the target so it doesn't look like it's doing a backhop
	rotation.y = -(Vector2(position.x, position.z)-Vector2(target.x, target.z)).angle() - PI/2
	# setup the values for the tween
	hop_target = target
	hop_height = height
	hop_duration = duration
	# start the tween
	update_tween()
	tween.play()
	# prevent jumping over and over, pretty self-explanatory ngl
	can_jump = false 
	# start cooldowns
	j_timer.start(8.0/Game.speed) # prevent the frog from jumping over and over by limiting them to the cooldown
	s_timer.start(1 + 2.0/Game.speed) # also start the cooldown for spitting with half the time to make it the first thing to happen next plus an offset so animations don't overlap


# signals

# timer/cooldown related signals
func _on_jump_timer_timeout(): can_jump = true
func _on_spit_timer_timeout(): can_spit = true

# stealing from player when it collides with it to discourage staying still
func _on_body_entered(body): if body.is_class("CharacterBody3D"): body.drop(randf_range(25, 50)) # check if it's a player so it doesn't try to steal food from a key and crash the Game on accident, would be very funny if it actually didn't tho lol
