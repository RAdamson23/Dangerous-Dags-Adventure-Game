extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var global_vars = get_node("/root/Globals")

# Called when the node enters the scene tree for the first time.
func _ready():
	if global_vars.mainCollectable == 2:
		global_vars.gotBonus = true
	$Information/Score/ScoreCount.set_text(str(global_vars.score))
	$Information/EnemiesDefeated/EnemiesDefeatedCount.set_text(str(global_vars.enemiesDefeated)+" x 5 points each")
	$Information/BonusesCollected/BonusesCollectedCount.set_text(str(global_vars.mainCollectable)+" x 50 points each")
	$Information/Deaths/DeathCount.set_text(str(global_vars.deathCount)+" x -20 points each")
	var totalscore = global_vars.scoreCalc()
	$Information/TotalScore/TotalScoreCount.set_text(str(totalscore))
	
	
	global_vars.score = totalscore
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Next_Level_pressed():
	
	global_vars.next_level()
	pass # Replace with function body.
