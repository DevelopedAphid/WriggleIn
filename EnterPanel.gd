extends Panel

func _ready():
	if Global.person_type_to_show == "Visitor":
		$VisitorNameTextEdit.visible = true
		$VisitorNameEnterButton.visible = true
	else:
		$VisitorNameTextEdit.visible = false
		$VisitorNameEnterButton.visible = false

func _on_BackButton_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainScreen.tscn")


func _on_VisitorNameEnterButton_button_up():
	var text_box = get_node("VisitorNameTextEdit")
	var person_name = text_box.text
	
	if person_name != "" && text_box.get_line_count() == 1:
		Global.add_new_person(person_name, "Visitor")
	
	text_box.text = ""
