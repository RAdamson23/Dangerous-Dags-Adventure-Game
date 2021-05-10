extends Node

onready var health = 6 setget set_health, get_health
onready var maxHealth = 6 setget set_maxHealth, get_maxHealth
onready var score = 0 setget set_score, get_score
onready var stamina = 5 setget set_stamina, get_stamina
onready var pies = 0 setget set_pies, get_pies
onready var next_scene setget set_next_scene, get_next_scene
onready var mainCollectable = 0 setget set_mainCollectable, get_mainCollectable
onready var current_scene = "res://Scenes/Cave.tscn" setget set_current_scene, get_current_scene
onready var enemiesDefeated = 0 setget set_enemiesDefeated, get_enemiesDefeated
onready var deathCount = 0
onready var gotBonus = false
onready var isDead = false setget set_isDead, get_isDead
onready var interstitial_Text
onready var interstitial_DefaultMusic = true


# Called when the node enters the scene tree for the first time.
func _ready():
	health = 6
	maxHealth = 6
	stamina = 5
	pies = 0
	mainCollectable = 0
	enemiesDefeated = 0
	isDead = false
	pass # Replace with function body.

func scoreCalc():
	var scoreCalc = (score+(enemiesDefeated*5)+(mainCollectable*50)+(deathCount*-20))
	mainCollectable = 0
	return scoreCalc
	

func level_complete():
	health = 6 
	maxHealth = 6 
	stamina = 5 
	pies = 0
	isDead = false
	get_tree().change_scene("res://Scenes/LevelComplete.tscn")
func next_level():
	deathCount = 0
	get_tree().change_scene(next_scene)
func onDeath():
	get_tree().change_scene("res://Scenes/DeathScene.tscn")
	deathCount+=1

func get_health():
	return health
	pass

func set_health(value):
	health = value
	pass
	
func get_isDead():
	return isDead
	pass

func set_isDead(value):
	isDead = value
	pass
	
	
func get_enemiesDefeated():
	return enemiesDefeated
	pass

func set_enemiesDefeated(value):
	enemiesDefeated = value
	pass
	
func get_current_scene():
	return current_scene
	pass

func set_current_scene(value):
	current_scene = value
	pass
	
func get_mainCollectable():
	return mainCollectable
	pass

func set_mainCollectable(value):
	mainCollectable = value
	pass
	
func get_maxHealth():
	return maxHealth
	pass

func set_maxHealth(value):
	maxHealth = value
	pass
	
func get_pies():
	return pies
	pass

func set_pies(value):
	pies = value
	pass
	
func get_score():
	return score
	pass

func set_score(value):
	score = value
	pass

func get_stamina():
	return stamina
	pass

func set_stamina(value):
	stamina = value
	pass
	
func get_next_scene():
	return next_scene
	pass

func set_next_scene(value):
	next_scene = value
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
