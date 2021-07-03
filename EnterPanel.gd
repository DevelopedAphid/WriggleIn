extends Panel

var dynamic_font = load("res://fonts/Open_Sans_Reg_40.tres")
var screen_size
var name_width_percent = 0.50
var time_width_percent = 0.20
var status_width_percent = 0.15
var button_width_percent = 0.10
var line_height
var bg_scene = preload("res://PersonBgPanel.tscn")
var person_scroll_container
var person_grid_container
var bg_scroll_container
var bg_vbox_container

func _ready():
	person_scroll_container = $PersonScrollContainer
	person_grid_container = $PersonScrollContainer/PersonVBoxContainer/PersonGridContainer
	bg_scroll_container = $BackgroundScrollContainer
	bg_vbox_container = $BackgroundScrollContainer/BackgroundVBoxContainer
	
	if Global.person_type_to_show == "Visitor":
		$VisitorNameTextEdit.visible = true
		$VisitorNameEnterButton.visible = true
		$CurrentVistorsLabel.visible = true
		person_scroll_container.anchor_top = 0.3
		person_scroll_container.anchor_bottom = 1.0
		bg_scroll_container.anchor_top = 0.3
		bg_scroll_container.anchor_bottom = 1.0
	else:
		$VisitorNameTextEdit.visible = false
		$VisitorNameEnterButton.visible = false
		$CurrentVistorsLabel.visible = false
		person_scroll_container.anchor_top = 0.0
		person_scroll_container.anchor_bottom = 1.0
		bg_scroll_container.anchor_top = 0.0
		bg_scroll_container.anchor_bottom = 1.0
	
	screen_size = get_viewport_rect().size
	line_height = (screen_size.y-65)/8
	
	create_list()
	
	#TODO: set fonts, colours, and dimensions up here

func create_list():	
	for n in Global.people_dict:
		var current_person = Global.get_person_with_string(n)
		if Global.person_type_to_show == "all" && Global.status_to_show == "all":
			load_person_into_list(current_person, n)
		elif current_person.Type == Global.person_type_to_show && current_person.Status == Global.status_to_show:
			load_person_into_list(current_person, n)

func load_person_into_list(current_person, person_string):
	var name_label = Label.new()
	person_grid_container.add_child(name_label)
	name_label.text = "  " + current_person.Name
	name_label.add_font_override("font", dynamic_font)
	name_label.add_color_override("font_color", Color(0,0,0,0.8))
	name_label.rect_min_size = Vector2(name_width_percent*screen_size.x, line_height)
	
	var time_label = Label.new()
	person_grid_container.add_child(time_label)
	time_label.text = current_person.Time_status_changed
	time_label.add_font_override("font", dynamic_font)
	time_label.add_color_override("font_color", Color(0,0,0,0.8))
	time_label.rect_min_size = Vector2(time_width_percent*screen_size.x, line_height)
	
	#TODO: remove in/out labels??
	var status_label = Label.new()
	person_grid_container.add_child(status_label)
	status_label.text = current_person.Status
	status_label.add_font_override("font", dynamic_font)
	status_label.add_color_override("font_color", Color(0,0,0,0.8))
	status_label.rect_min_size = Vector2(status_width_percent*screen_size.x, line_height)
	
	var status_button = Button.new()
	person_grid_container.add_child(status_button)
	if current_person.Status == "in":
		status_button.icon = load("res://icons/switch_on.svg")
	elif current_person.Status == "out":
		status_button.icon = load("res://icons/switch_off.svg")
	status_button.flat = true
	status_button.rect_min_size = Vector2(button_width_percent*screen_size.x, line_height)
	status_button.expand_icon = true
	status_button.connect("pressed", self, "_on_StatusButton_pressed", [person_string, status_button, person_grid_container.get_child_count()])
	
	var person_background = bg_scene.instance()
	bg_vbox_container.add_child(person_background)
	person_background.rect_min_size = Vector2(screen_size.x - 15, line_height)

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
	
	person_grid_container.get_child(index-2).text = Global.get_person_with_string(person).Status
	person_grid_container.get_child(index-3).text = Global.get_person_with_string(person).Time_status_changed

func _on_VisitorNameEnterButton_button_up():
	var text_box = get_node("VisitorNameTextEdit")
	var person_name = text_box.text
	
	if person_name != "" && text_box.get_line_count() == 1:
		Global.add_new_person(person_name, "Visitor")
	
	text_box.text = ""
	
	get_tree().change_scene("res://MainScreen.tscn")


func _on_AdminButton_button_up():
	get_tree().change_scene("res://AdminScreen.tscn")
