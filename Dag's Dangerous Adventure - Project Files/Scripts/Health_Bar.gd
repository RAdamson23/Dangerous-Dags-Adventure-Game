extends Node

signal max_changed(new_max)
signal changed(new_amount)
signal depleted()

onready var global_vars
onready var max_amount setget set_max
onready var current_health setget set_current_health
onready var player 
onready var playerEffects 
onready var SFX
onready var HUDAnimationPlayer

var canBeDamaged = true
var timeInvulnerable = 1

func _ready():
	if get_node("/root/Cave") != null:
		global_vars = get_node("/root/Globals")
		max_amount = global_vars.maxHealth
		current_health = global_vars.health
		player = get_node("/root/Cave").get_node("Player")
		playerEffects = get_node("/root/Cave").get_node("Player").get_node("PlayerEffects")
		HUDAnimationPlayer = get_node("/root/Cave/MainHUD/HealthBar")
	_intialize()
	

func set_max(new_max):
	max_amount = new_max
	max_amount = max(1,new_max)
	emit_signal("max_changed",max_amount)
	
func set_current_health(new_value):	
	if new_value >= current_health:
		current_health = new_value
		current_health = clamp(current_health,0,max_amount)
		global_vars.health = current_health
		emit_signal("changed",current_health)
	elif canBeDamaged:
		current_health = new_value
		current_health = clamp(current_health,0,max_amount)
		global_vars.health = current_health
		if current_health == 0:
			emit_signal("depleted")
			current_health = max_amount
			global_vars.onDeath()
		elif global_vars.isDead == false:
			damage()
			emit_signal("changed",current_health)
	if current_health <= 2:
		HUDAnimationPlayer.play("HealthBarFlash")
	else:
		HUDAnimationPlayer.play("HealthBarRest")
		
	
	

func _intialize():
	emit_signal("max_changed",max_amount)
	emit_signal("changed",current_health)

func damage():
	if !canBeDamaged:
		return
	if playerEffects != null && player != null:
		player.motion.y = player.JUMP_HEIGHT * 0.8
		player.get_node("Oof").play()
		playerEffects.play("Damaged")
		playerEffects.queue("Visible")
		canBeDamaged = false
		yield(get_tree().create_timer(timeInvulnerable),"timeout")
		canBeDamaged = true
		if playerEffects != null:
			playerEffects.play("Rest")
	if get_node("/root/Cave") != null:
		player = get_node("/root/Cave").get_node("Player")
		playerEffects = get_node("/root/Cave").get_node("Player").get_node("PlayerEffects")
