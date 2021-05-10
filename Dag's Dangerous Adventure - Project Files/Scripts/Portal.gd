extends Node2D
onready var global_vars = get_node("/root/Globals")
onready var HUDAnimationPlayer = get_node("/root/Cave/MainHUD/HealthBar")
onready var player = get_node("/root/Cave/Player")
onready var caveScript = get_node("/root/Cave")
onready var playerHealth = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Health_Bar_Script")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		if global_vars.pies==3:
			playerHealth.canBeDamaged = false
			player.get_node("PlayerEffects").play("Visible")
			player.get_node("PlayerStates").play("Idle")
			player.ispaused = true
			yield(get_tree().create_timer(1.5),"timeout")
			player.get_node("PlayerEffects").play("Rest")
			player.ispaused = false
			playerHealth.canBeDamaged = true
			player.get_node("Hitbox/CollisionShape2D").call_deferred("set_disabled", false)
			if global_vars.current_scene != "res://Scenes/CaveLevel2.tscn":
				global_vars.level_complete()
			else:
				get_tree().change_scene("res://Scenes/GameComplete.tscn")
			
		else:
			HUDAnimationPlayer.play("PieCounterTextFlash")
			yield(get_tree().create_timer(1.5),"timeout")
			HUDAnimationPlayer.play("Rest")
			
