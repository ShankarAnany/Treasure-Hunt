extends Node

onready var animation_player = $AnimationPlayer

func play_transition(transition):
	animation_player.play(transition)
