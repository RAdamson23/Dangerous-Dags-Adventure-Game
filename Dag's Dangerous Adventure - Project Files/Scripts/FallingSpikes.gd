extends Node2D

var speed = 130
var velocity = Vector2(0,0)
const FLOOR = Vector2(0,-1)
export var size_x = 40
export var size_y = 40
export var damage = 1.5
onready var playerHealth = get_node("/root/Cave/MainHUD").get_node("CanvasLayer/Control/Health_Bar_Script")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var isFalling = false

func _process(delta):
	if isFalling:
		velocity.x = 0
		velocity.y += speed
		$KinematicBody2D.move_and_slide(velocity,FLOOR)

func startFalling():
	$AnimationPlayer.play("Shaking")
	yield(get_tree().create_timer(0.4),"timeout")
	isFalling = true
	$AnimationPlayer.stop()

func _on_DetectionBox_body_entered(body):
	if body.name == "Player":
		startFalling()


func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		playerHealth.current_health-=damage
	if body.is_in_group("Fireball"):
		startFalling()
	if isFalling == true:
		$KinematicBody2D/CollisionShape2D.call_deferred("set_disabled", true)
		


func _on_Timer_timeout():
	$DetectionBox/CollisionShape2D.call_deferred("set_disabled", true)
	$KinematicBody2D/Sprite.visible = false
	queue_free()
