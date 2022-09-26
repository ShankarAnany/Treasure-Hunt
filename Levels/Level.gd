extends Node2D

const player_scene = preload("res://Player/Player.tscn")

onready var camera = $Camera2D
onready var player = $Player

var player_pos = Vector2.ZERO

var score = 0

func _ready():
	player.connect_camera(camera)
	player_pos = player.global_position
	Events.connect("player_died", self, "on_player_died")
	Events.connect("checkpoint", self, "on_hit_checkpoint")
	Events.connect("collected", self, "on_collect")

func on_player_died():
	var new_player = player_scene.instance()
	add_child(new_player)
	new_player.global_position = player_pos
	new_player.connect_camera(camera)

func on_hit_checkpoint(position):
	player_pos = position

func on_collect(value):
	score += value
	$Background/Label.text = str(score)
