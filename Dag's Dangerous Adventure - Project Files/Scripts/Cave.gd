extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var global_vars = get_node("/root/Globals")
onready var PiesCollected = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/PieCounter")
onready var mPos = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Position")
onready var Score = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Score")
onready var MainCollectable = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/MainCollectableCounter")
onready var eDefeated = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/EnemiesDefeated")
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control").visible = true
	global_vars.next_scene = "res://Scenes/CaveLevel2.tscn"
	global_vars.current_scene = "res://Scenes/Cave.tscn"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	PiesCollected.set_text("Pies: " + str(global_vars.pies)+" / 3")
	Score.set_text("Score: " + str(global_vars.score))
	MainCollectable.set_text("Bonuses: " + str(global_vars.mainCollectable) + " / 2")
	mPos.set_text("Mouse Position: " + str(get_viewport().get_mouse_position()))
	eDefeated.set_text("Enemies Defeated: " + str(global_vars.enemiesDefeated))
