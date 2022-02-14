extends Panel

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
var no_activity_timer

func _ready():
	person_scroll_container = $PersonScrollContainer
	person_grid_container = $PersonScrollContainer/PersonVBoxContainer/PersonGridContainer
	bg_scroll_container = $BackgroundScrollContainer
	bg_vbox_container = $BackgroundScrollContainer/BackgroundVBoxContainer
	
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
		if current_person.Status == "in": #only load ins since we are evacuating
			load_person_into_list(current_person, n)

func load_person_into_list(current_person, person_string):
	var list_font = Global.list_font
	var name_label = Label.new()
	person_grid_container.add_child(name_label)
	name_label.text = "  " + current_person.Name
	name_label.add_font_override("font", list_font)
	name_label.add_color_override("font_color", Color(0,0,0,0.8))
	name_label.rect_min_size = Vector2(name_width_percent*screen_size.x, line_height)
	name_label.valign = Label.VALIGN_CENTER
	
	var time_label = Label.new()
	person_grid_container.add_child(time_label)
	time_label.text = current_person.Time_status_changed
	time_label.add_font_override("font", list_font)
	time_label.add_color_override("font_color", Color(0,0,0,0.8))
	time_label.rect_min_size = Vector2(time_width_percent*screen_size.x, line_height)
	time_label.valign = Label.VALIGN_CENTER
	
	#TODO: remove in/out labels??
	var status_label = Label.new()
	person_grid_container.add_child(status_label)
	status_label.text = current_person.Status
	status_label.add_font_override("font", list_font)
	status_label.add_color_override("font_color", Color(0,0,0,0.8))
	status_label.rect_min_size = Vector2(status_width_percent*screen_size.x, line_height)
	status_label.valign = Label.VALIGN_CENTER
	
	var status_button = Button.new()
	person_grid_container.add_child(status_button)
	status_button.icon = load("res://icons/cross_mark.png")
	status_button.flat = true
	status_button.rect_min_size = Vector2(button_width_percent*screen_size.x, line_height)
	status_button.expand_icon = true
	status_button.connect("pressed", self, "_on_StatusButton_pressed", [person_string, status_button, person_grid_container.get_child_count()])
	
	var person_background = bg_scene.instance()
	bg_vbox_container.add_child(person_background)
	person_background.rect_min_size = Vector2(screen_size.x - 15, line_height)

func _on_BackButton_button_up():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://AdminScreen.tscn")

func _on_StatusButton_pressed(_person, button, index):
	button.icon = load("res://icons/check_mark.png")
	
	person_grid_container.get_child(index-2).text = "OK"

