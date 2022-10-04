extends Label

var ms = 0
var s = 0
var currentTimer = 0
var lap = 0

func _process(delta):
	
	if lap <= 3:
		if ms > 9:
			s+=1
			ms = 0
		
		set_text(str(s)+":"+str(ms))
		currentTimer = str(s)+":"+str(ms)
		pass


func _on_Timer_timeout():
	ms += 1
	
	pass # Replace with function body.


func resetTimer():
	if lap == 0:
		lap += 1
	elif lap == 1:
		$Lap3.set_text(currentTimer)
		lap += 1
		ms = 0
		s = 0
	elif lap == 2:
		$Lap2.set_text(currentTimer)
		lap += 1
		ms = 0
		s = 0
	else:
		lap += 1
		set_text("DONE")
