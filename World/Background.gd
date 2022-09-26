extends CanvasLayer

export(int) var cloud_speed = -15

onready var clouds = $Clouds
onready var clouds_2 = $Clouds2

func _process(delta):

	if clouds.position.x <= -224:
		clouds.position.x = 543
	if clouds_2.position.x <= -224:
		clouds_2.position.x = 543

	clouds.position.x += cloud_speed * delta
	clouds_2.position.x += cloud_speed * delta
