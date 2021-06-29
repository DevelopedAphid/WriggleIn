extends Panel

var dynamic_font = load("res://fonts/Open_Sans_Reg_40.tres")

func _ready():
	if Global.person_type_to_show == "Visitor":
		$VisitorNameTextEdit.visible = true
		$VisitorNameEnterButton.visible = true
	else:
		$VisitorNameTextEdit.visible = false
		$VisitorNameEnterButton.visible = false
	
	create_list()
	
	#TODO: set fonts, colours, and dimensions up here

func create_list():
	load_headings_into_list()
	
	for n in Global.people_dict:
		var current_person = Global.get_person_with_string(n)
		if Global.person_type_to_show == "all" && Global.status_to_show == "all":
			load_person_into_list(current_person, n)
		elif current_person.Type == Global.person_type_to_show && current_person.Status == Global.status_to_show:
			load_person_into_list(current_person, n)

func load_headings_into_list():
	var grid_container = $PersonScrollContainer/PersonVBoxContainer/PersonGridContainer
	
	var name_label = Label.new()
	grid_container.add_child(name_label)
	name_label.text = "Name"
	name_label.add_font_override("font", dynamic_font)
	name_label.add_color_override("font_color", Color(0,0,0,1))
	name_label.rect_min_size = Vector2(350, 45)
	
	var time_label = Label.new()
	grid_container.add_child(time_label)
	time_label.text = "Time in/out"
	time_label.add_font_override("font", dynamic_font)
	time_label.add_color_override("font_color", Color(0,0,0,1))
	
	#TODO: remove in/out labels??
	var status_label = Label.new()
	grid_container.add_child(status_label)
	status_label.text = "Status"
	status_label.add_font_override("font", dynamic_font)
	status_label.add_color_override("font_color", Color(0,0,0,1))
	
	var button_label = Label.new()
	grid_container.add_child(button_label)
	button_label.text = "    "
	button_label.add_font_override("font", dynamic_font)
	button_label.add_color_override("font_color", Color(0,0,0,1))

func load_person_into_list(current_person, person_string):
	var grid_container = $PersonScrollContainer/PersonVBoxContainer/PersonGridContainer
	
	var name_label = Label.new()
	grid_container.add_child(name_label)
	name_label.text = current_person.Name
	name_label.add_font_override("font", dynamic_font)
	name_label.add_color_override("font_color", Color(0,0,0,0.8))
	name_label.rect_min_size = Vector2(350, 45)
	
	var time_label = Label.new()
	grid_container.add_child(time_label)
	time_label.text = current_person.Time_status_changed
	time_label.add_font_override("font", dynamic_font)
	time_label.add_color_override("font_color", Color(0,0,0,0.8))
	
	#TODO: remove in/out labels??
	var status_label = Label.new()
	grid_container.add_child(status_label)
	status_label.text = current_person.Status
	status_label.add_font_override("font", dynamic_font)
	status_label.add_color_override("font_color", Color(0,0,0,0.8))
	
	var status_button = Button.new()
	grid_container.add_child(status_button)
	if current_person.Status == "in":
		status_button.icon = load("res://icons/switch_on.svg")
	elif current_person.Status == "out":
		status_button.icon = load("res://icons/switch_off.svg")
	status_button.flat = true
#	status_button.grow_horizontal = false
	status_button.rect_min_size = Vector2(45,45)
	status_button.expand_icon = true
	status_button.connect("pressed", self, "_on_StatusButton_pressed", [person_string, status_button, grid_container.get_child_count()])

func _on_BackButton_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://MainScreen.tscn")

func _on_StatusButton_pressed(person, button, index):
# warning-ignore:return_value_discarded
	var new_status = Global.change_person_status_from_string(person)
	
	if new_status == "in":
		button.icon = load("res://icons/switch_on.svg")
	elif new_status == "out":
		button.icon = load("res://icons/switch_off.svg")
	
	print(index)
	var grid_container = $PersonScrollContainer/PersonVBoxContainer/PersonGridContainer
	grid_container.get_child(index-2).text = Global.get_person_with_string(person).Status
	grid_container.get_child(index-3).text = Global.get_person_with_string(person).Time_status_changed

func _on_VisitorNameEnterButton_button_up():
	var text_box = get_node("VisitorNameTextEdit")
	var person_name = text_box.text
	
	if person_name != "" && text_box.get_line_count() == 1:
		Global.add_new_person(person_name, "Visitor")
	
	text_box.text = ""
