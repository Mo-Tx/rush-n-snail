class_name Player extends CharacterBody3D

@export var SPEED = 5.0

var game : Game
var direction : Vector3

var time := 10.0

func _ready(): 
	game = get_tree().current_scene
	game.player = self

func _process(delta): 
	time -= delta * game.speed
	if time <= 0: queue_free()
	
	if !is_on_floor(): velocity.y -= game.SETTINGS["GRAVITY"] * delta
	var input_dir = Input.get_vector("LEFT", "RIGHT", "FORWARD", "BACK")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
func collect(): time += 2.5
