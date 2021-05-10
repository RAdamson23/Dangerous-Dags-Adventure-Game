extends Control
var dialogue = []        
export var path = "res://Dialogue/Intro.txt"


onready var player = get_node("/root/Cave/Player")
onready var NPC = get_node("/root/Cave/NPC/KinematicBody2D/InteractButton")
onready var global_vars = get_node("/root/Globals")

var dialog_index = 0
var finished = false
var dagIsSpeaking = true
func _ready():
	if path == "res://Dialogue/Outro.txt" && global_vars.gotBonus == true:
			path = "res://Dialogue/OutroGotBonus.txt"
	var file = File.new()
	file.open(path, file.READ)
	while !file.eof_reached():
		var line = file.get_line()
		dialogue.append(line)
	file.close()
	pass

func _process(delta):
	$Sprite.visible = finished
	if Input.is_action_just_pressed("Mouse_Left_Click") && self.visible == true:
		NPC.visible = false
		load_dialog()
	

func load_dialog():
	player.ispaused = true
	get_node("/root/Cave/Player/PlayerStates").play("Idle")
	if dialog_index < dialogue.size():
		finished = false
		$AnimationPlayer.stop()
		if dagIsSpeaking:
			$Baker.visible = !dagIsSpeaking
			$Dag.visible = dagIsSpeaking
		else:
			$Baker.visible = !dagIsSpeaking
			$Dag.visible = dagIsSpeaking
		
		$RichTextLabel.bbcode_text = dialogue[dialog_index]
		$RichTextLabel.percent_visible = 0
		$Tween.interpolate_property(
			$RichTextLabel, "percent_visible", 0, 1, 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Tween.start()
	else:
		self.visible = false
		dialog_index = 0
		get_tree().change_scene("res://Scenes/Interstitial.tscn")
		player.ispaused = false
	dialog_index += 1
	if dagIsSpeaking == true:
		dagIsSpeaking = false
	else:
		dagIsSpeaking = true
	


func _on_Tween_tween_completed(object, key):
	$AnimationPlayer.play("Vibrate")
	finished = true
	
