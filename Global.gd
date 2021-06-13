extends Node

signal person_list_changed

var status_to_show: String = "all"
var person_type_to_show: String = "all"

var person_dict = [{
		"Name": "Employee1",
		"Status": "in",
		"Time_status_changed": "00:00",
		"Type": "Employee"
	},
	{
		"Name": "AEmployee2",
		"Status": "out",
		"Time_status_changed": "00:00",
		"Type": "Employee"
	},
	{
		"Name": "AEmployee3",
		"Status": "out",
		"Time_status_changed": "00:00",
		"Type": "Employee"
	},
	{
		"Name": "AAVisitor1",
		"Status": "in",
		"Time_status_changed": "00:00",
		"Type": "Visitor"
	},
	{
		"Name": "ABVisitor2",
		"Status": "in",
		"Time_status_changed": "00:00",
		"Type": "Visitor"
	}]

func _ready():
	#low processor usage mode refreshes screen only when needed
	OS.low_processor_usage_mode = true
	
	#TODO sort the dictionary alphabetically by name 
	#TODO stick this all in a sort function once sorting!
	
	#add ID numbers on ready
	assign_id_numbers()


func assign_id_numbers():
	for n in person_dict.size():
		person_dict[n].ID = n

func add_new_person(Name: String, Type: String):
	var new_person_dict = {"Name": Name, "Type": Type, "Status": "in", "Time_status_changed": "00:00"}
	person_dict.append(new_person_dict)
	assign_id_numbers()
	
	emit_signal("person_list_changed")

func remove_a_person(ID: int):
	person_dict.remove(ID)
	
	emit_signal("person_list_changed")

func change_person_status(ID_Number: int) -> String:
	var current_status = person_dict[ID_Number].Status
	if current_status == "in":
		current_status = "out"
	elif current_status == "out":
		current_status = "in"
	
	person_dict[ID_Number].Status = current_status
	
	var time = "%02d:%02d" % [OS.get_datetime().hour, OS.get_datetime().minute]
	person_dict[ID_Number].Time_status_changed = time
	
	return current_status

func change_status_to_show(new_status: String):
	status_to_show = new_status

func change_person_type_to_show(new_status: String):
	person_type_to_show = new_status

func remove_previous_visitors():
	var people_to_remove = []
	for n in person_dict.size():
		var current_person = person_dict[n]
		if current_person.Type == "Visitor" && current_person.Status == "out":
			people_to_remove.append(current_person.ID)
	for n in people_to_remove.size():
		Global.remove_a_person(people_to_remove[n])

func save_employee_list():
	var saved_list = File.new()
	saved_list.open("user://employee_list.dat", File.WRITE)
	saved_list.store_string(str(person_dict))
	saved_list.close()

func load_employee_list() -> String:
	var list_to_load = File.new()
	list_to_load.open("user://employee_list.dat", File.READ)
	var content = list_to_load.get_as_text()
	list_to_load.close()
	return content
