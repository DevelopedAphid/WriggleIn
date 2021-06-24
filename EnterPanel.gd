extends Panel

var dynamic_font = load("res://fonts/Open_Sans_Light_20.tres")

func _ready():
	if Global.person_type_to_show == "Visitor":
		$VisitorNameTextEdit.visible = true
		$VisitorNameEnterButton.visible = true
	else:
		$VisitorNameTextEdit.visible = false
		$VisitorNameEnterButton.visible = false
	
	update_list()

func update_list():
	for n in Global.people_dict.size():
		var current_person = Global.get_person(n)
		
		var name_label = Label.new()
		$PersonScrollContainer/PersonVBoxContainer/PersonGridContainer.add_child(name_label)
		name_label.text = current_person.Name
		name_label.add_font_override("font", dynamic_font)
		
		var time_label = Label.new()
		$PersonScrollContainer/PersonVBoxContainer/PersonGridContainer.add_child(time_label)
		time_label.text = current_person.Time_status_changed
		time_label.add_font_override("font", dynamic_font)
		
		var status_label = Label.new()
		$PersonScrollContainer/PersonVBoxContainer/PersonGridContainer.add_child(status_label)
		status_label.text = current_person.Status
		status_label.add_font_override("font", dynamic_font)
		
		var status_button = Button.new()
		$PersonScrollContainer/PersonVBoxContainer/PersonGridContainer.add_child(status_button)
		status_button.icon = load("res://art/office_small.svg")

func _on_BackButton_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainScreen.tscn")


func _on_VisitorNameEnterButton_button_up():
	var text_box = get_node("VisitorNameTextEdit")
	var person_name = text_box.text
	
	if person_name != "" && text_box.get_line_count() == 1:
		Global.add_new_person(person_name, "Visitor")
	
	text_box.text = ""
