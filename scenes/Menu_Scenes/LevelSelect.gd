extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# the node enters the scene tree for the first time.
func _ready():
	$Menu/CenterRow/Beach.grab_focus()
	
	for button in $Menu/CenterRow.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.scene_to_load])


func _on_Button_pressed(scene_to_load):
	get_tree().change_scene(scene_to_load)
