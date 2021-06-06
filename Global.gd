extends Node

signal person_added

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
		"Name": "AAVisitor1",
		"Status": "in",
		"Time_status_changed": "00:00",
		"Type": "Visitor"
	}
]

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
	print(person_dict)

func add_new_person(Name: String, Type: String):
	var new_person_dict = {"Name": Name, "Type": Type, "Status": "out", "Time_status_changed": "00:00"}
	person_dict.append(new_person_dict)
	assign_id_numbers()
	
	emit_signal("person_added")

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
