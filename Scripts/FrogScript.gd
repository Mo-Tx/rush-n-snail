class_name Frog extends Area3D

var game : Game
var tween : Tween
var j_timer : Timer
var s_timer : Timer
var anim : AnimationPlayer

var can_jump := true
var can_spit := false

var key := preload("res://Scenes/key.tscn")

func _ready(): 
	randomize()
	game = get_tree().current_scene
	tween = create_tween()
	j_timer = $JumpTimer
	s_timer = $SpitTimer
	anim = $Model/AnimationPlayer

func _process(delta): 
	if tween.finished && anim.current_animation != "Frog_Spit": 
		if position.distance_to(game.player.position) <= 10 && can_jump: 
			var p_pos = game.player.position
			rotation.y = -(Vector2(position.x, position.z)-Vector2(p_pos.x, p_pos.z)).angle() - PI/2
			hop(p_pos, 2, position.distance_to(p_pos)/5 / game.speed)
		elif can_spit: 
			randomize()
			rotation.y = randf_range(-180, 180)
			var power = randf_range(1, 6)
			anim.play("Frog_Spit", -1, power*game.speed)
			spit(power, 2)
			can_spit = false
		elif !anim.is_playing(): anim.play("Frog_Idle", -1, game.speed)
		
	
func hop(target, height, duration):
	anim.stop()
	s_timer.stop()
	tween = create_tween()
	tween.tween_property(self, "position", Vector3((position.x+target.x)/2, height, (position.z+target.z)/2), duration/2)
	tween.tween_property(self, "position", target, duration/3)
	
	can_jump = false
	j_timer.start(8/game.speed)
	s_timer.start(1 + 2/game.speed)
	
func spit(distance, duration):
	var key_ins = key.instantiate()
	key_ins.position.x = position.x
	key_ins.position.z = position.z
	game.level.add_child(key_ins)
	tween = create_tween()
	tween.tween_property(key_ins, "position", Vector3(key_ins.position.x+sin(rotation.y)*distance, key_ins.position.y, key_ins.position.z+cos(rotation.y)*distance), duration/distance/game.speed)
	s_timer.start(4/game.speed)

func _on_jump_timer_timeout(): can_jump = true

func _on_spit_timer_timeout(): can_spit = true
