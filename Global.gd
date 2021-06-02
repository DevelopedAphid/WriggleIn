extends Node

var employee_dict = [{
		"name": "Employee 1",
		"status": "in",
		"time_status_changed": "8:21am"
	},
	{
		"name": "Employee 2",
		"status": "out",
		"time_status_changed": "8:23am"		
	}
]

func _ready():
	print(employee_dict[1])
	pass # Replace with function body.

