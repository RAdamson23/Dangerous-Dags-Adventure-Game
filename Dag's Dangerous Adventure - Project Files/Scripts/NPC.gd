extends KinematicBody2D

var velocity = Vector2(0,0)
const GRAVITY = 20
const SPEED = 140
const FLOOR = Vector2(0,-1)
var dir = 0
var direction = 1
var is_moving_left = false
var isIdle = false
var isInteracting = false
var isDialog = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Mouse_Left_Click") && isInteracting:
		isDialog = true
	if !isInteracting:
		if !isIdle:
			$AnimatedSprite.play("Walk")
			velocity.x = -direction * 100
		else:
			$AnimatedSprite.play("Idle")
			velocity.x =  0
		velocity = move_and_slide(velocity,Vector2(0,-1))
	else:
		return

func _on_stateTimer_timeout():
	isIdle = false


func _on_Bounds_body_entered(body):
	if body.is_in_group("NPC"):
		switchPos()
		isIdle = true
		$stateTimer.start(2.5)
func switchPos():
	direction *= -1
	$AnimatedSprite.flip_h = !$AnimatedSprite.flip_h
	var bounds = get_node("../Bounds/BoundsCS")
	var boundsArea = get_node("../Bounds/BoundsCS")
	bounds.position.x *= -1


func _on_Interaction_Range_body_entered(body):
	if body.name == "Player":
		$InteractButton.visible = true
		get_node("InteractButton/AnimationPlayer").play("MoveUPDOWN")
		if body.global_position.x < global_position.x:
			#On it's left
			if $AnimatedSprite.flip_h == false:
				$AnimatedSprite.flip_h = true
		else:
			if $AnimatedSprite.flip_h == true:
				$AnimatedSprite.flip_h = false
		isInteracting = true
		$AnimatedSprite.play("Idle")
		velocity.x =  0
		velocity = move_and_slide(velocity,Vector2(0,-1))
	

func _on_Interaction_Range_body_exited(body):
	if body.name == "Player":
		$InteractButton.visible = false
		get_node("InteractButton/AnimationPlayer").stop()
	if direction == -1:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	isInteracting = false
	pass # Replace with function body.
