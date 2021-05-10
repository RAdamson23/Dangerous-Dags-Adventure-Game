extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var global_vars = get_node("/root/Globals")


# Called when the node enters the scene tree for the first time.
func _ready():
	global_vars.interstitial_Text = "Dangerous Dag was on track to become the best pie maker in the world, the last thing he needed was the teachings of the famed baker Mr. Tarte.\nMr. Tarte was very elusive. But after searching for years, Dag finally ventured into page two of Google's search results and discovered his location..."
	global_vars.interstitial_DefaultMusic = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	global_vars._ready()
	global_vars.next_scene = "res://Scenes/introscene.tscn"
	get_tree().change_scene("res://Scenes/Interstitial.tscn")
	pass # Replace with function body.


func _on_Exit_pressed():
	get_tree().quit()
	pass # Replace with function body.
