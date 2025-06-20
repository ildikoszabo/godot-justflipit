class_name Task extends Node

var taskName:Globals.TaskNames 
var nrOfTriggersNeeded:int 
var triggersNeeded:Array[Globals.Triggers] 
var triggersReceived:Array[Globals.Triggers] 
var taskIcon:Sprite2D
var isCompleted: = false
var taskTimeSeconds:int 


static func create_task(ntaskName:Globals.TaskNames, ntriggersNeeded:int, ntriggers:Array[Globals.Triggers], ntaskTimeSeconds, icon:Sprite2D):
	var instance = Task.new()
	instance.taskName = ntaskName
	instance.nrOfTriggersNeeded = ntriggersNeeded
	instance.triggersNeeded = ntriggers	
	instance.isCompleted = false
	instance.taskTimeSeconds = ntaskTimeSeconds
	instance.taskIcon = icon
	return instance
