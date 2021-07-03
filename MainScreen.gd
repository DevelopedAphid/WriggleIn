extends Control

#emoji from openmoji.org

func _ready():
	#clean up old visitors every time we get to the main screen
	Global.remove_previous_visitors()

func _on_EnterButton_button_up():
	Global.change_status_to_show("out")
	Global.change_person_type_to_show("Employee")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://EnterScreen.tscn")

func _on_LeaveButton_button_up():
	Global.change_status_to_show("in")
	Global.change_person_type_to_show("Employee")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://EnterScreen.tscn")

func _on_VisitorsButton_button_up():
	Global.change_status_to_show("in")
	Global.change_person_type_to_show("Visitor")
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://EnterScreen.tscn")
