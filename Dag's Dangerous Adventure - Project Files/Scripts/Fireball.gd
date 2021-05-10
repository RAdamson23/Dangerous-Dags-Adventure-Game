extends RigidBody2D



export var speed = 800
func _ready():
	$Whoosh.play()
	apply_impulse(Vector2(),Vector2(speed,0).rotated(rotation))

func Explode():
	$Timer.start()
	$CollisionShape2D.call_deferred("set_disabled", true)
	$Fireball.play("Explode")
	

func _on_VisibilityNotifier2D_screen_exited():
	$Timer.start(1)

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.

func _on_Fireball_body_entered(body):
	if body.name != "Player":
		Explode()

#func _integrate_forces(state):
#	for i in state.get_contact_count():
#		var collider = state.get_contact_collider_object(i)
#		var cpos = state.get_contact_collider_position(i)
#		var n = state.get_contact_local_normal(i)
#		emit_signal('collided',collider,cpos,n,bodyType)
