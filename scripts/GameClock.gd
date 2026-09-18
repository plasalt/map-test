extends Node

#varibles
var minutes : int = 0
var hours : int = 6
var days : int = 0

#added minutes to the time
func add_minutes(amount : int):
	minutes += amount
	
	#time praser 
	while minutes >= 60:
		minutes -= 60
		hours += 1
	while hours >= 24:
		hours -= 24
		days += 1

#the function to the set the time
func settime(amount: int):
	days = amount / 1440
	hours = (amount % 1440) / 60
	minutes = amount % 60

# this function returns a formated verison of the time
func formate_time():
	return ("%d:%02d" % [hours, minutes])

#this fgunction returns the time 
func get_time():
	return (hours*100+minutes)
	
#this time gets the time in full minutes
func get_time_minutes():
	return ((days*24*60)+(hours*60)+(minutes))
	
