extends Area2D

onready var global_vars = get_node("/root/Globals")
onready var stamina = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Stamina_Bar_Script")
onready var health = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Health_Bar_Script")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_body_entered(body):
	if body.name == "Player":
		global_vars.pies += 1
		global_vars.score += 15
		health.current_health+=1.5
		stamina.current_stamina+=2
		queue_free()
		$CollisionShape2D.call_deferred("set_disabled", true)
		
