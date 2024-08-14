class_name Player extends CharacterBody3D

@onready var fruit_scene := Game.fruit # done for performence reasons

@onready var limit := Game.SETTINGS.MAP_SIZE

var SPEED : float
var direction : Vector3
var model : Node3D
var hitbox : CollisionShape3D
var anim : AnimationPlayer

var food := 0
var time := "x:xx" # time converted to readable format to be displayed in the HUD (combines the 2 next variables)
var time_m := int(Game.SETTINGS.START_TIME) # the minutes of the displayed time
var time_s := (Game.SETTINGS.START_TIME-time_m)*100 # the seconds of the displayed time

@onready var SE := $AudioStreamPlayer3D

func _ready(): 
	# Setup
	Game.player = self # declating self as the player of the game for communication
	
	SPEED = Game.SETTINGS.SPEED_MULTIPLIER #setting the static speed of self according to the game settings so it doesn't feel slow
	
	model = $Model
	hitbox = $CollisionShape3D
	anim = $Model/AnimationPlayer

func _process(delta): if Game.state == Game.STATE.PLAYING: # put this next to any function that is related to the gameplay (not RI)
	# Update time, movement, and animations
	# Time management
	time_s -= delta * Game.speed # update the time based on the game speed (main mechanic)
	
	if time_m <= 0 && time_s <= 0: Game.end(food)  # run things that you want to happen when you lose here
	
	if time_s <= 0: # reduce minutes by 1 when seconds reach 0 and add 60 to the seconds
		time_s = 60
		time_m -= 1
	elif time_s >= 60: # add 1 to the minutes and reset the seconds if enough get added to reach over 60 (not really used since time is always going down but added to prevent bugs)
		time_s -= 60
		time_m += 1
	time = str(time_m) + ":" + (str(int(time_s)).pad_zeros(2)) # format the new time
	
	# Movement and animations (probably obvious enough)
	var input_dir = Input.get_vector("LEFT", "RIGHT", "FORWARD", "BACK")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		SE.pitch_scale = Game.speed/2.0 + 0.5
		if !SE.playing: SE.play()
		anim.play("Snail_WalkCycle", -1, Game.speed)
		velocity.x = direction.x * SPEED * Game.speed
		velocity.z = direction.z * SPEED * Game.speed
		model.rotation.y = -input_dir.angle() - PI/2 # because the 3D editor is very smart i had to hardcode extra 90 degrees in the rotation
		hitbox.rotation.y = -input_dir.angle() - PI/2 # because of that i also realised that i have to do the same for the collision shape
	else:
		SE.stop()
		anim.play("Snail_Idle", -1, Game.speed)
		velocity.x = move_toward(velocity.x, 0, SPEED * Game.speed)
		velocity.z = move_toward(velocity.z, 0, SPEED * Game.speed)
	
	move_and_slide()
	position.x = clampf(position.x, -limit, limit)
	position.z = clampf(position.z, -limit, limit)
	
	if Game.state == Game.STATE.PAUSED: anim.pause()

func collect(type): if Game.state == Game.STATE.PLAYING:
	# collection handling
	match type:
		Game.COLLECTABLES.KEY: Game.speed += 1
		Game.COLLECTABLES.LOCK: Game.speed -= 1
		Game.COLLECTABLES.TIMER: time_s += 45
		Game.COLLECTABLES.FRUIT: food += 1
		
	Game.speed = clampi(Game.speed, 1, 11) #clamp the game speed so it doesnt go too fast

func drop(percentage): 
	
	var init_food = food
	
	food = clampi(food*(percentage/100), 0, 100)
	
	for i in init_food-food:
	
		var fruit = fruit_scene.instantiate()
		var direction = randf_range(-180, 180)
		var distance = randf_range(2, 5)
	
		fruit.lifetime = 10
	
		Game.level.add_child(fruit)
	
		fruit.position.x = position.x
		fruit.position.z = position.z
	
		fruit.throw(direction, distance, 2)
	
