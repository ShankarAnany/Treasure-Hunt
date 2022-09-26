extends Area2D

export(String, FILE, "*.tscn") var target_level = ""

func _on_LevelMap_body_entered(body):
	if not body is Player: return
	if target_level.empty(): return
	change_level(target_level)

func change_level(target_level):
	get_tree().paused = true
	SceneTransition.play_transition("LevelExit")
	yield(SceneTransition.animation_player, "animation_finished")
	get_tree().change_scene(target_level)
	SceneTransition.play_transition("LevelEnter")
	get_tree().paused = false
