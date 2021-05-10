extends KinematicBody2D

onready var playerHealth = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Health_Bar_Script")
onready var player = get_node("/root/Cave/Player")
onready var global_vars = get_node("/root/Globals")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2(0,0)
const GRAVITY = 20
const SPEED = 280
const FLOOR = Vector2(0,-1)
var react_time = 200
var dir = 0
var next_dir = 0
var next_dir_time = 0
var next_jump_time = -1
var health = 2
const JUMP_HEIGHT = -550
var is_dead = false
export var damage = 2
var isHit = false
var eye_reach = 90
var direction = 1
var vision = 600
var isRunning = 0
var is_moving_left = false
var firstrun = true
var playerDetectorExited = true
var hasSeenPlayer = false
var ANIMATIONS = {"IDLE": "Idle","RUN": "Run","ATTACK": "Attack","HIT": "Hit","DEAD": "Dead"}


# Called when the node enters the scene tree for the first time.
func _ready():
	changeAnimation("IDLE")
	pass # Replace with function body.
	
func sees_player():
	var eye_center = get_global_position()
	var eye_top = eye_center + Vector2(0,-eye_reach)
	var eye_left = eye_center + Vector2(-eye_reach,0)
	var eye_right = eye_center + Vector2(eye_reach,0)
	
	var player_pos = player.get_global_position()
	var player_extents = player.get_node("CollisionShape2D").shape.extents - Vector2(1,1)
	var top_left = player_pos + Vector2(-player_extents.x, -player_extents.y)
	var top_right = player_pos + Vector2(player_extents.x, -player_extents.y)
	var bottom_left = player_pos + Vector2(-player_extents.x, player_extents.y)
	var bottom_right = player_pos + Vector2(player_extents.x, player_extents.y)
	
	var space_state = get_world_2d().direct_space_state
	
	for eye in [eye_center,eye_top,eye_left,eye_right]:
		for corner in [top_left,top_right,bottom_left,bottom_right]:
			if (corner-eye).length() > vision:
				continue
			var collision = space_state.intersect_ray(eye,corner,[],1)
			if collision and collision.collider.name == "Player":
				return true
	return false
	
func switchPos():
	$RayCast2D.position.x *= -1
	$PlayerDetector/CollisionShape2D.position.x *= -1
	$AttackDetector/CollisionShape2D.position.x *= -1
	$Hitbox/CollisionShape2D.position.x *= -1

func _process(delta):
	
	if !is_dead && sees_player():
		hasSeenPlayer = true
		if !playerDetectorExited:
			attack()
			velocity.y += GRAVITY
			velocity = move_and_slide(velocity,FLOOR)
			return
		if $EnemyStates.current_animation == "ATTACK" || isHit:
				return
		if $EnemyStates.current_animation != "RUN":
			changeAnimation("RUN")
		if player.position.x < position.x:
			set_dir(-1)
			if is_moving_left == false:
				is_moving_left = true
			changeAnimation("RUN")
			if direction != -1:
				switchPos()
				direction *= -1
		elif player.position.x > position.x:
			set_dir(1)
			if is_moving_left == true:
				is_moving_left = false
			changeAnimation("RUN")
			if direction != 1:
				switchPos()
				direction *= -1
		else:
			set_dir(0)
		if OS.get_ticks_msec() > next_dir_time:
			dir = next_dir
		if OS.get_ticks_msec() > next_jump_time  && next_jump_time != -1 && is_on_floor():
			if player.position.y < position.y - 64 and sees_player():
				velocity.y = JUMP_HEIGHT
			next_jump_time = -1
		velocity.x = dir * SPEED
		if player.position.y < position.y - 64 and next_jump_time == -1 and sees_player():
			next_jump_time = OS.get_ticks_msec() + react_time
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity,FLOOR)
		pass
	elif !is_dead && hasSeenPlayer:
		movecharacter()
	elif !is_dead:
		changeAnimation("IDLE")
		velocity.x = 0
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity,FLOOR)

func movecharacter():
	if firstrun:
		if $EnemyStates.current_animation != "RUN":
			changeAnimation("RUN")
		velocity.x = dir * SPEED
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity,FLOOR)
		if is_on_wall() || !$RayCast2D.is_colliding():
			firstrun = false
	else:
		if $EnemyStates.current_animation != "RUN":  
			changeAnimation("RUN")
		if is_on_wall():
			is_moving_left = !is_moving_left
			$Animations/Run.flip_h = is_moving_left
			direction = direction * -1
			switchPos()
		if !$RayCast2D.is_colliding():
			is_moving_left = !is_moving_left
			$Animations/Run.flip_h = is_moving_left			
			direction = direction * -1
			switchPos()
		velocity.x = SPEED * direction
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity,FLOOR)
			
func hit():
	$AttackDetector.monitoring = true
	
func end_of_hit():
	$AttackDetector.monitoring = false
	
func start_run():
	changeAnimation("RUN")

func changeAnimation(state):
	for sprite in $Animations.get_children():
		if sprite.name != ANIMATIONS[state]:
			sprite.hide()
		else:
			sprite.flip_h = is_moving_left	
			sprite.show()
	$EnemyStates.play(state)

func _on_Timer_timeout():
	queue_free()

func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time

func onHit():
	if !hasSeenPlayer:
			hasSeenPlayer = true
			firstrun = false
	$Hit.play()
	isHit = true
	health-=1
	velocity.x = 0
	velocity = move_and_slide(velocity,Vector2.UP)
	changeAnimation("HIT")
	yield(get_tree().create_timer(0.25),"timeout")
	isHit = false
func dead():
	$Death.play()
	is_dead = true
	global_vars.enemiesDefeated+=1
	velocity = Vector2(0,0)
	changeAnimation("DEAD")
	$CollisionShape2D.call_deferred("set_disabled", true)
	$PlayerDetector/CollisionShape2D.call_deferred("set_disabled", true)
	$AttackDetector/CollisionShape2D.call_deferred("set_disabled", true)
	$Hitbox/CollisionShape2D.call_deferred("set_disabled", true)
	velocity.x = 0
	while !is_on_floor():
		velocity.y+=GRAVITY
		move_and_slide(velocity,FLOOR)
	$Timer.start()

func _on_Hitbox_body_entered(body):
	if body.is_in_group("Fireball") || body.is_in_group("FallingSpikes"):
		if health > 0:
			onHit()
		else:
			dead()
func attack():
	velocity.x = 0
	$Attack.play()
	changeAnimation("ATTACK")

func _on_PlayerDetector_body_entered(body):
	if body.name == "Player":
		playerDetectorExited = false
		attack()

func _on_AttackDetector_body_entered(body):
	if body.name == "Player":
		playerHealth.current_health-=damage


func _on_PlayerDetector_body_exited(body):
	playerDetectorExited=true
	pass # Replace with function body.
