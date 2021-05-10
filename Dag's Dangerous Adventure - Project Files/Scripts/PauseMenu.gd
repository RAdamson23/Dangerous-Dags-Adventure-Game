extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Resume.grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if $Resume.is_hovered():
		$Resume.grab_focus()
	if $Exit2Menu.is_hovered():
		$Exit2Menu.grab_focus()
	if $Quit.is_hovered():
		$Quit.grab_focus()
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$Resume.grab_focus()
		get_tree().paused = !get_tree().paused
		visible = !visible


func _on_Resume_pressed():
	get_tree().paused = !get_tree().paused
	visible = !visible



func _on_Exit2Menu_pressed():
	get_tree().paused = !get_tree().paused
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")

func _on_Quit_pressed():
	get_tree().paused = !get_tree().paused
	get_tree().quit()
