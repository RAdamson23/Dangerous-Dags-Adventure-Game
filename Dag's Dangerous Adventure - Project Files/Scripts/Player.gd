extends KinematicBody2D

var plFireball := preload("res://Scenes/Fireball.tscn")
onready var global_vars = get_node("/root/Globals")
export var can_fire = true
var rate_of_fire = 0.4
var regen_Stamina_timeout = 0.7
var regen_Stamina_rate = 0.6
var shooting = false
var max_num_dub_jumps = 1
var dub_jumps = 0
var can_jump = false

onready var stamina = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Stamina_Bar_Script")
onready var health = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Health_Bar_Script")
onready var player = get_node("/root/Cave").get_node("Player").get_node("Sprite")
onready var HUDAnimationPlayer = get_node("/root/Cave/MainHUD/StaminaBar")
onready var player_states = $PlayerStates
onready var player_effects = $PlayerEffects

const UP = Vector2(0, -1)

const ACCELERATION = 80
var knockback = 20
var ispaused = false
var MAX_SPEED = 280
const GRAVITY = 25
const JUMP_HEIGHT = -650
var spriteFlip = false
var move_direction
onready var motion = Vector2() setget set_current_motion,get_current_motion
func set_current_motion(new_value):
	motion = new_value
func get_current_motion():
	return motion

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
func _process(delta):
	if stamina.current_stamina < stamina.max_amount && !Input.is_action_just_released("Mouse_Left_Click") || !Input.is_action_just_released("ui_up") && global_vars.isDead == false:
		stamina.current_stamina += regen_Stamina_rate*delta
	if Input.is_action_pressed("Mouse_Left_Click") and can_fire == true:
		if stamina.current_stamina > 1:
			if HUDAnimationPlayer.current_animation == "StaminaBarFlash":
				HUDAnimationPlayer.play("StaminaBarRest")
			shoot()
		else:
			HUDAnimationPlayer.play("StaminaBarFlash")
	

func isDead():
	global_vars.isDead = true
	motion = Vector2(0,0)
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Timer.start()
	$PlayerEffects.play("Visible")
var isJumping = false

func _physics_process(_delta):
	if !global_vars.isDead && ispaused == false:
		motion.y += GRAVITY
		var friction = false
		if Input.is_action_pressed("ui_right"):
			player.flip_h = false #flip sprite to face direction
			motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
			player_states.play("Run")
		elif Input.is_action_pressed("ui_left"):
			player.flip_h = true #flip sprite to face direction
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
			player_states.play("Run")
		else:
			friction = true
			player_states.play("Idle")
			
		if Input.is_action_just_pressed("ui_up"):
			isJumping = true
			if can_jump:
				motion.y = JUMP_HEIGHT	
			elif dub_jumps > 0  && stamina.current_stamina > 1:
				motion.y = JUMP_HEIGHT
				dub_jumps -= 1
				stamina.current_stamina-=0.8
		
		if is_on_floor():
			can_jump = true
			dub_jumps = max_num_dub_jumps
			if friction == true:
				motion.x = lerp(motion.x,0,0.2)
		else:
			
			can_jump = false
			if friction == true:
				motion.x = lerp(motion.x,0,0.05)
			if motion.y < 0:
				player_states.play("Jump")
			else:
				player_states.play("Fall")
				isJumping = false
		if is_on_wall() && stamina.current_stamina > 1 && (Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_left")):
			if stamina.current_stamina > 0.5:
				dub_jumps = max_num_dub_jumps
				if Input.is_action_just_pressed("ui_up"):
					stamina.current_stamina -= 0.5
		var snap = Vector2.DOWN * 32 if !isJumping else Vector2.ZERO
		motion = move_and_slide_with_snap(motion,snap,UP)

func shoot():
		can_fire = false
		stamina.current_stamina -= 1
		get_node("TurnAxis").rotation = get_angle_to(get_global_mouse_position())
		player.flip_h = spriteFlip
		player_states.play("Attack")
		var fireball_instance = plFireball.instance()
		fireball_instance.position = get_node("TurnAxis/CastPoint").get_global_position()
		fireball_instance.rotation = get_angle_to(get_global_mouse_position())
		get_parent().add_child(fireball_instance)
		yield(get_tree().create_timer(rate_of_fire),"timeout")
		can_fire = true
