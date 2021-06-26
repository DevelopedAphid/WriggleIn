extends Panel

var dynamic_font = load("res://fonts/Open_Sans_Light_20.tres")

func _ready():
	if Global.person_type_to_show == "Visitor":
		$VisitorNameTextEdit.visible = true
		$VisitorNameEnterButton.visible = true
	else:
		$VisitorNameTextEdit.visible = false
		$VisitorNameEnterButton.visible = false
	
	create_list()

func create_list():
	for n in Global.people_dict:
		var current_person = Global.get_person_with_string(n)
		if Global.person_type_to_show == "all" && Global.status_to_show == "all":
			load_person_into_list(current_person, n)
		elif current_person.Type == Global.person_type_to_show && current_person.Status == Global.status_to_show:
			load_person_into_list(current_person, n)

func load_person_into_list(current_person, person_string):
	var grid_container = $PersonScrollContainer/PersonVBoxContainer/PersonGridContainer
		
	var name_label = Label.new()
	grid_container.add_child(name_label)
	name_label.text = current_person.Name
	name_label.add_font_override("font", dynamic_font)
	
	var time_label = Label.new()
	grid_container.add_child(time_label)
	time_label.text = current_person.Time_status_changed
	time_label.add_font_override("font", dynamic_font)
	
	#TODO: remove in/out labels??
	var status_label = Label.new()
	grid_container.add_child(status_label)
	status_label.text = current_person.Status
	status_label.add_font_override("font", dynamic_font)
	
	var status_button = Button.new()
	grid_container.add_child(status_button)
	#TODO: this icon should depend on current status
	status_button.icon = load("res://art/office_small.svg")
	status_button.flat = true
	status_button.grow_horizontal = false
	status_button.rect_min_size = Vector2(32,32)
	status_button.connect("pressed", self, "_on_StatusButton_pressed", [person_string, status_button])

func _on_BackButton_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainScreen.tscn")

func _on_StatusButton_pressed(person, button):
	var current_person = Global.get_person_with_string(person)
	print(str(current_person.Name))
	#TODO: change status and update list
# warning-ignore:return_value_discarded
	var new_status = Global.change_person_status_from_string(person)
	
	if new_status == "in":
		button.icon = load("res://icons/switch_on.svg")
	elif new_status == "out":
		button.icon = load("res://icons/switch_off.svg")

func _on_VisitorNameEnterButton_button_up():
	var text_box = get_node("VisitorNameTextEdit")
	var person_name = text_box.text
	
	if person_name != "" && text_box.get_line_count() == 1:
		Global.add_new_person(person_name, "Visitor")
	
	text_box.text = ""
