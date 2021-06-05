extends Panel

func _ready():
	pass # Replace with function body


func _on_BackButton_button_up():
	get_tree().change_scene("res://MainScreen.tscn")


func _on_EnterButton_button_up():
	#TODO: new function: Global.add_new_person(person info)
	Global.add_new_person("New", "Employee")
