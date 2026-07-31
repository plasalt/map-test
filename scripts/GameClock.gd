extends Node

var minutes : int = 0
var hours : int = 6
var days : int = 0

func add_minutes(amount : int):
	minutes += amount

	while minutes >= 60:
		minutes -= 60
		hours += 1
	while hours >= 24:
		hours -= 24
		days += 1

func settime(amount: int):
	days = amount / 1440
	hours = (amount % 1440) / 60
	minutes = amount % 60

func formate_time():
	return ("%d:%02d" % [hours, minutes])


func get_time():
	return (hours*100+minutes)
	
func get_time_minutes():
	return ((days*24*60)+(hours*60)+(minutes))
	
