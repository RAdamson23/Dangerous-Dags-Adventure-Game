extends Node2D

onready var player = get_node("/root/Cave").get_node("Player/")
onready var NPC = get_node("/root/Cave/NPC/KinematicBody2D")
onready var global_vars = get_node("/root/Globals")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control").visible = false
	global_vars.next_scene = "res://Scenes/Cave.tscn"
	global_vars.interstitial_Text = "One very long walk later..."
	global_vars.interstitial_DefaultMusic = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Mouse_Left_Click") && NPC.isInteracting: 
		get_node("/root/Cave/Player/Control").visible = true
		player.ispaused = true
	if !NPC.isInteracting:
		player.ispaused = false
	pass


