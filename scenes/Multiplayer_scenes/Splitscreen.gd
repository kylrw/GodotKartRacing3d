extends Node

func _input(event):
	if event.is_action_pressed("ui_cancel"):
				get_tree().change_scene("res://scenes/Menu_Scenes/TitleScreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	#print($Viewports.rect_scale.x)
