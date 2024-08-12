class_name Frog extends Area3D

var game : Game
var j_tween : Tween
var s_tween : Tween
var j_timer : Timer # jump timer for cooldown
var s_timer : Timer # spit timer, for cooldown too
var anim : AnimationPlayer

var can_jump := true
var can_spit := false
# (self-explanatory btw)

var key := preload("res://Scenes/key.tscn") # rewatch your godot tutorials if you legit didn't get this and actually resorted to reading the comment

func _ready(): 
	# setup, should be obvious enough
	randomize()
	
	game = get_tree().current_scene
	
	j_tween = create_tween()
	s_tween = create_tween()
	
	j_timer = $JumpTimer
	s_timer = $SpitTimer
	anim = $Model/AnimationPlayer

func _process(_delta): if !(game.ended && game.paused): #frog main behaviour loop
	if j_tween.finished && s_tween.finished && anim.current_animation != "Frog_Spit":  # check if no animations/tweens other than idle are splaying before doing the spaghetti machine (state machine but spaghetti)
		if can_jump: # jumping, first priority if the cooldown has ended
			var p_pos = game.player.position # player position to save the hassle of writing all of that so much, that's why it's exclusive to the scope
			
			if position.distance_to(p_pos) <= 7: # jump to the player if close enough
				hop(p_pos, 2, position.distance_to(p_pos)/5 / game.speed)
			
			else: # jump to a random position nearby if not so the frog doesn't just idle and keep spitting keys making them all cluttererd up
				var r_pos = position + Vector3(randf_range(-10, 10),0, randf_range(-10, 10))
				if r_pos.x > 100 || r_pos.y > 100: r_pos = position + Vector3(randf_range(-10, 10),0, randf_range(-10, 10)) # if the random position goes too fer then redo another one 
				hop(r_pos, 2, position.distance_to(r_pos)/10 / game.speed)
		
		elif can_spit: #spit a key to a random pisition nearby if the jump colldown didn't end yet but the spitting one did
			rotation.y = randf_range(-180, 180)
			var power = randf_range(1, 6)
			anim.play("Frog_Spit", -1, power*game.speed)
			spit(power, 2)
			can_spit = false
			
		elif !anim.is_playing(): anim.play("Frog_Idle", -1, game.speed) # if no cooldowns are up wait for all animations to endthen idle
		
	
# frog behavious	
	
func hop(target, height, duration): # hopping animation and some cooldown behaviour
	anim.stop()
	s_timer.stop()
	rotation.y = -(Vector2(position.x, position.z)-Vector2(target.x, target.z)).angle() - PI/2
	j_tween = create_tween()
	j_tween.tween_property(self, "position", Vector3((position.x+target.x)/2, height, (position.z+target.z)/2), duration/2).set_ease(Tween.EASE_OUT)
	j_tween.tween_property(self, "position", target, duration/2).set_ease(Tween.EASE_IN)
	
	j_tween.play()
	
	can_jump = false 
	j_timer.start(8.0/game.speed)
	# prevent the frog from jumping over and over by limiting them to the colldown
	s_timer.start(1 + 2.0/game.speed) #also start the cooldown for spitting with half the time to make it the first thing to happen next plus an offset so animations don't overlap
	
func spit(distance, duration): # spitting behaviour then doing the cooldown etc self explanatory just read
	
	var key_ins = key.instantiate() # we only need this here so make the variable in this scope
	
	key_ins.position.x = position.x
	key_ins.position.z = position.z
	# make the key take the position of the frog but only in x and z because it's a 2.5D game plus a flyting key isn't realistic anyway
	
	game.level.add_child(key_ins)
	s_tween = create_tween()
	# basic setup no need to explain
	
	s_tween.tween_property(key_ins, "position", Vector3(key_ins.position.x+sin(rotation.y)*distance, key_ins.position.y, key_ins.position.z+cos(rotation.y)*distance), duration/distance/game.speed).set_ease(Tween.EASE_OUT)
	# tween the spitting of the key so it doesn't look like it teleported from the outside of the frog's mouth
	
	s_tween.play()
	
	s_timer.start(4.0/game.speed) #restart the normal cooldown

# timer/cooldown related signals

func _on_jump_timer_timeout(): can_jump = true

func _on_spit_timer_timeout(): can_spit = true


func _on_body_entered(body): if body.is_class("CharacterBody3D"):
	body.food -= randi_range(1, 3)
	body.food = clampi(body.food, 0, 100)
