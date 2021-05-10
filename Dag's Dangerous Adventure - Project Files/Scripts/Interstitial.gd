extends Node2D
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var global_vars = get_node("/root/Globals")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Information/SubTitle.text = global_vars.interstitial_Text
	$Information/SubTitle.percent_visible = 0
	$Tween.interpolate_property(
		$Information/SubTitle, "percent_visible", 0, 1, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	$Tween.start()
	$"next-indicator/AnimationPlayer".play("InterstitialMoveUpDown")
	if global_vars.next_scene == "res://Scenes/TitleScreen.tscn":
		$GameComplete.play()
		return
	if global_vars.interstitial_DefaultMusic:
		$Default.play()
		$Spongebob.stop()
	else:
		$Default.stop()
		$Spongebob.play()
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Mouse_Left_Click"):
		get_tree().change_scene(global_vars.next_scene)
	pass
