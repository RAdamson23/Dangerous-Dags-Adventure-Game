extends Area2D

tool
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var isFlipped = false
var isOpen = 0
onready var door = get_node("../Door")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_DoorOpenBox_body_entered(body):
	if body.name == "Player":
		if isOpen == 0:
			door.play("Open")
			isOpen = 1
	



func _on_DoorOpenBox_body_exited(body):
	if body.name == "Player":
		if isOpen == 1:
			door.play("Closed")
			isOpen = 0
	pass # Replace with function body.
