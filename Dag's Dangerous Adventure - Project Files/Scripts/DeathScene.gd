extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var global_vars = get_node("/root/Globals")

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(0, 2)
	if my_random_number == 1:
		$PleaseStandBy.play()
	else:
		$CurbYourEnthusiasm.play()
	$Information/Score/ScoreCount.set_text(str(global_vars.score))
	$Information/EnemiesDefeated/EnemiesDefeatedCount.set_text(str(global_vars.enemiesDefeated)+" x 5 points each")
	$Information/BonusesCollected/BonusesCollectedCount.set_text(str(global_vars.mainCollectable)+" x 50 points each")
	$Information/Deaths/DeathCount.set_text(str(global_vars.deathCount)+" x -20 points each")
	$Information/TotalScore/TotalScoreCount.set_text(str(global_vars.scoreCalc()))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass	


func _on_Restart_pressed():
	get_tree().change_scene(global_vars.current_scene)
	global_vars._ready()

