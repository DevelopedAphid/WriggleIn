extends Control

func _on_EnterButton_button_up():
	Global.change_status_to_show("out")
	get_tree().change_scene("res://EnterScreen.tscn")


func _on_AdminButton_button_up():
	get_tree().change_scene("res://AdminScreen.tscn")


func _on_LeaveButton_button_up():
	Global.change_status_to_show("in")
	get_tree().change_scene("res://EnterScreen.tscn")


func _on_AllEmployeesButton_button_up():
	Global.change_status_to_show("all")
	get_tree().change_scene("res://EnterScreen.tscn")
