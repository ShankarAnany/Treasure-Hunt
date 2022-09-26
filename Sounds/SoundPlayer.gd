extends Node

const MUSIC = preload("res://Sounds/music.wav")
const HURT = preload("res://Sounds/hurt.wav")
const JUMP = preload("res://Sounds/jump.wav")
const CHECKPOINT = preload("res://Sounds/checkpoint.wav")
const COLLECT = preload("res://Sounds/collect.wav")

onready var audio_players = $AudioPLayers
onready var music_player = $MusicPlayer

func _ready():
	music_player.play()

func play_sound(sound):
	for player in audio_players.get_children():
		if not player.playing:
			player.stream = sound
			player.play()
			break

func _on_MusicPlayer_finished():
	music_player.play()
