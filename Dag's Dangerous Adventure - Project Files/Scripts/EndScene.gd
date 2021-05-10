extends Node2D

onready var player = get_node("/root/Cave").get_node("Player/")
onready var NPC = get_node("/root/Cave/NPC/KinematicBody2D")
onready var global_vars = get_node("/root/Globals")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	global_vars.interstitial_Text = "And so Dag the Apprentice worked for the next few years under the wing of Mr. Tarte.\nNo one knows what the duo is doing currently, but I'm sure they're having fun.\n\nThanks for playing!"
	get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control").visible = false
	$Objects/Main/Collection4/Chips.visible = global_vars.gotBonus
	global_vars.next_scene = "res://Scenes/TitleScreen.tscn"
	global_vars.interstitial_DefaultMusic = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Mouse_Left_Click") && NPC.isInteracting: 
		get_node("/root/Cave/Player/Control").visible = true
		player.ispaused = true
	if !NPC.isInteracting:
		player.ispaused = false
	pass
