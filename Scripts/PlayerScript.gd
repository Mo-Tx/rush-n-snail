class_name Player extends CharacterBody3D

var SPEED : float
var direction : Vector3
var game : Game
var model : Node3D
var anim : AnimationPlayer

var food := 0
var time := "x:xx" # time converted to readable format to be displayed in the HUD (combines the 2 next variables)
var time_m := 5 # the minutes of the displayed time
var time_s := 1.0 # the seconds of the displayed time

func _ready(): 
	# Setup
	game = get_tree().current_scene
	game.player = self # declating self as the player of the game for communication
	
	SPEED = game.SETTINGS["SPEED_MULTIPLIER"] #setting the static speed of self according to the game settings so it doesn't feel slow
	
	model = $Model
	anim = $Model/AnimationPlayer

func _process(delta): if !(game.ended || game.paused): # put this next to any function that is related to the gameplay (not RI)
	# Update time, movement, and animations
	# Time management
	time_s -= delta * game.speed # update the time based on the game speed (main mechanic)
	
	if time_m <= 0 && time_s <= 0: game.end(food)  # run things that you want to happen when you lose here
	
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
		anim.play("Snail_WalkCycle", -1, game.speed)
		velocity.x = direction.x * SPEED * game.speed
		velocity.z = direction.z * SPEED * game.speed
		model.rotation.y = -input_dir.angle() - PI/2 # because the 3D editor is very smart i had to hardcode extra 90 degrees in the rotation
		model.rotation.y = -input_dir.angle() - PI/2 # because of that i also realised that i have to do the same for the collision shape
	else:
		anim.play("Snail_Idle", -1, game.speed)
		velocity.x = move_toward(velocity.x, 0, SPEED * game.speed)
		velocity.z = move_toward(velocity.z, 0, SPEED * game.speed)
	
	move_and_slide()
	position = position.clamp(Vector3(-100, -1, -100), Vector3(100, 1, 100))

func collect(type): if !(game.ended && game.paused):
	# collection handling
	match type:
		Game.COLLECTABLES.KEY: game.speed += 1
		Game.COLLECTABLES.LOCK: game.speed -= 1
		Game.COLLECTABLES.TIMER: time_s += 30
		Game.COLLECTABLES.FRUIT: food += 1
		
	game.speed = clampi(game.speed, 1, 11) #clamp the game speed so it doesnt go too fast
