extends ItemList

func _on_EmployeeNameList_employee_added(employee_id):
	add_item(str(Global.person_dict[employee_id].Status))


func _on_EmployeeNameList_item_selected(index):
	select(index)
