class_name Player extends CharacterBody3D

var SPEED : float

var direction : Vector3
var game : Game
var model : Node3D
var anim : AnimationPlayer

var time := "x:xx"
var time_m := 5
var time_s := 1.0

func _ready(): 
	game = get_tree().current_scene
	game.player = self
	SPEED = game.SETTINGS["SPEED_MULTIPLIER"]
	model = $Model
	anim = $Model/AnimationPlayer

func _process(delta): 
	time_s -= delta * game.speed
	if time_m <= 0 && time_s <= 0: queue_free()
	if time_s <= 0: 
		time_s = 60
		time_m -= 1
	elif time_s >= 60: 
		time_s -= 60
		time_m += 1
	if str(int(time_s)).length() == 1 : time = str(time_m) + ":0" + str(int(time_s))
	else: time = str(time_m) + ":" + str(int(time_s))
	
	#if !is_on_floor(): velocity.y -= game.SETTINGS["GRAVITY"] * delta
	var input_dir = Input.get_vector("LEFT", "RIGHT", "FORWARD", "BACK")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if direction:
		anim.play("Snail_WalkCycle")
		velocity.x = direction.x * SPEED * game.speed
		velocity.z = direction.z * SPEED * game.speed
		model.rotation.y = -input_dir.angle() - PI/2
	else:
		anim.play("Snail_Idle")
		velocity.x = move_toward(velocity.x, 0, SPEED * game.speed)
		velocity.z = move_toward(velocity.z, 0, SPEED * game.speed)
	
	move_and_slide()
	
func collect(): game.speed += 1
