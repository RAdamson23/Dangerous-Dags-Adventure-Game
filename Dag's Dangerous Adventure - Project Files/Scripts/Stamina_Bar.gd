extends Node

signal max_changed(new_max)
signal changed(new_amount)
signal depleted

export (int) var max_amount = 5 setget set_max
onready var current_stamina = max_amount setget set_current


func _ready():
	current_stamina=max_amount
	_intialize()
	

func set_max(new_max):
	max_amount = new_max
	max_amount = max(1,new_max)
	emit_signal("max_changed",max_amount)
	
func set_current(new_value):
	current_stamina = new_value
	current_stamina = clamp(current_stamina,0,max_amount)
	emit_signal("changed",current_stamina)
	
	if current_stamina == 0:
		emit_signal("depleted")
		
func _intialize():
	emit_signal("max_changed",max_amount)
	emit_signal("changed",current_stamina)
