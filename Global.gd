extends Node

var person_dict = [{
		"Name": "Employee1",
		"Status": "in",
		"Time_status_changed": "8:21am",
		"Type": "Employee"
	},
	{
		"Name": "AEmployee2",
		"Status": "out",
		"Time_status_changed": "8:23am",
		"Type": "Employee"
	},
	{
		"Name": "AAVisitor1",
		"Status": "in",
		"Time_status_changed": "8:35am",
		"Type": "Visitor"
	}
]

func _ready():
	#TODO sort the dictionary alphabetically by name 
	#TODO stick this all in a sort function once sorting!
	
	#add ID numbers on ready
	assign_id_numbers()


func assign_id_numbers():
	for n in person_dict.size():
		person_dict[n].ID = n
	print(person_dict)

func add_new_person(Name: String, Type: String):
	var new_person_dict = {"Name": Name, "Type": Type}
	print(new_person_dict)
	person_dict.append(new_person_dict)
	assign_id_numbers()
	print(person_dict)
	pass
