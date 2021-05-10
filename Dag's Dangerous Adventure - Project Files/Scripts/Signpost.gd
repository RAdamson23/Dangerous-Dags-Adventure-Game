extends Node2D

export var text = "Sample Text"


func _on_Hitbox_body_entered(body):
	if body.name == "Player":
		$Label.text = text
		$Label.visible = true
		$AnimationPlayer.play("typewriter")
		$AnimationPlayer.queue("Rest")
	


func _on_Hitbox_body_exited(body):
	if body.name == "Player":
		$AnimationPlayer.play("reverse")
		#$Label.visible = false
