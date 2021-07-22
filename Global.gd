extends Node

#icons are from flaticon.com by freepik and roundicons and pixel perfect

signal person_list_changed

var status_to_show: String = "all"
var person_type_to_show: String = "all"

var enter_image
var exit_image
var list_font
var troll_font

var people_dict = {}

func _ready():
	#low processor usage mode refreshes screen only when needed
	OS.low_processor_usage_mode = true
	
	people_dict = load_people_list()
	sort_person_list()
	
#	OS.window_fullscreen = true
	
	enter_image = load("res://art/in_photo_1.jpg")
	exit_image = load("res://art/out_photo_1.jpg")
	list_font = load("res://fonts/sofia_40.tres")
	troll_font = load("res://fonts/comic_40.tres")

func get_person(dict_key) -> Dictionary:
	return people_dict.get("Person " + str(dict_key))
	
func get_person_with_string(dict_key) -> Dictionary:
	return people_dict.get(dict_key)

func add_new_person(Name: String, Type: String):
	var new_people_dict = {"Name": Name, "Type": Type, "Status": "in", "Time_status_changed": get_current_time()}
	people_dict["Person " + str(people_dict.size())] = new_people_dict
	
	sort_person_list()
	save_people_list()
	emit_signal("person_list_changed")

func remove_a_person(ID):
	people_dict.erase("Person " + str(ID))
	var new_people_dict = {}
	for n in people_dict:
		new_people_dict["Person " + str(new_people_dict.size())] = get_person_with_string(n)
	
	people_dict.clear()
	for n in new_people_dict.size():
		people_dict["Person " + str(n)] = new_people_dict["Person " + str(n)]
	
	sort_person_list()
	save_people_list()
	emit_signal("person_list_changed")

func sort_person_list():
	var unsorted_people = []
	for n in people_dict.size():
		unsorted_people.append(get_person(n))
	
	unsorted_people.sort_custom(self, "custom_comparison")
	
	var new_people_dict = {}
	for n in unsorted_people.size():
		new_people_dict["Person " + str(n)] = unsorted_people[n]
	
	people_dict.clear()
	people_dict = new_people_dict

func custom_comparison(a,b):
	if typeof(a) != typeof(b):
		return typeof(a) < typeof(b)
	else:
		return a.Name < b.Name

func change_person_status(ID_Number) -> String:
	ID_Number = str(ID_Number) #as dictionary expects string not int
	var current_status = get_person(ID_Number).Status
	if current_status == "in":
		current_status = "out"
	elif current_status == "out":
		current_status = "in"
	
	get_person(ID_Number).Status = current_status
	get_person(ID_Number).Time_status_changed = get_current_time()
	
	save_people_list()
	
	return current_status

func change_person_status_from_string(person) -> String:
	var current_person = get_person_with_string(person)
	var current_status = current_person.Status
	if current_status == "in":
		current_status = "out"
	elif current_status == "out":
		current_status = "in"
	
	current_person.Status = current_status
	current_person.Time_status_changed = get_current_time()
	
	save_people_list()
	
	return current_status

func get_current_time() -> String:
	var time = "%02d:%02d" % [OS.get_datetime().hour, OS.get_datetime().minute]
	return time

func change_status_to_show(new_status: String):
	status_to_show = new_status

func change_person_type_to_show(new_status: String):
	person_type_to_show = new_status

func remove_previous_visitors():
	var people_to_remove = []
	for n in people_dict.size():
		var current_person = get_person(n)
		if current_person.Type == "Visitor" && current_person.Status == "out":
			people_to_remove.append(n)
	for n in people_to_remove.size():
		Global.remove_a_person(people_to_remove[n])

func save_people_list():
	var saved_list = File.new()
	saved_list.open("user://people_list.json", File.WRITE)
	saved_list.store_string(to_json(people_dict))
	saved_list.close()

func load_people_list() -> Dictionary:
	#TODO: needs to handle the file not existing yet
	var list_to_load = File.new()
	list_to_load.open("user://people_list.json", File.READ)
	var content = list_to_load.get_as_text()
	content = parse_json(content)
	list_to_load.close()
	return content
