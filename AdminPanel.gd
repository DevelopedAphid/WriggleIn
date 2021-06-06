extends Panel

func _ready():
	pass # Replace with function body


func _on_BackButton_button_up():
	get_tree().change_scene("res://MainScreen.tscn")


func _on_EnterButton_button_up():
	var text_box = get_node("NameTextEdit")
	var person_name = text_box.text
	
	if person_name != "" && text_box.get_line_count() == 1:
		Global.add_new_person(person_name, "Employee")
	
	text_box.text = ""
