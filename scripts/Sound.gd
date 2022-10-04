extends Node

onready var background_music = get_parent().get_node("GameRoot/BackgroundMusic")

func ready():
	background_music._set_playing(true)
