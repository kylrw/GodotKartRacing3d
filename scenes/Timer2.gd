extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Area_body_shape_exited(body_id, body, body_shape, area_shape):
	$Label.resetTimer()
