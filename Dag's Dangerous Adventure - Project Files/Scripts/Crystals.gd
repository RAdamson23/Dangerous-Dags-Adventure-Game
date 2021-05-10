extends Area2D

onready var stamina = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Stamina_Bar_Script")
onready var health = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Health_Bar_Script")
onready var global_vars = get_node("/root/Globals")

export var mode = "Health"
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Rest")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Crystal_body_entered(body):
	if body.is_in_group("Player") || body.is_in_group("Fireball"):
		if mode == "Health":
			health.current_health+=1.5
		elif mode == "Stamina":
			stamina.current_stamina+=2.5
		else:
			global_vars.score+=5
		$CollisionShape2D.call_deferred("set_disabled", true)
		$AnimationPlayer.play("Flash")
		$Timer.start()
		


func _on_Timer_timeout():
	queue_free()
