class_name Task extends Node

var taskName:Globals.TaskNames 
var nrOfTriggersNeeded:int 
var triggersNeeded:Array[Globals.Triggers] 
var triggersReceived:Array[Globals.Triggers] 
var taskIcon:String
var isCompleted: = false
var taskTimeSeconds:int 
var score:int


static func create_task(ntaskName:Globals.TaskNames, ntriggersNeeded:int, ntriggers:Array[Globals.Triggers], ntaskTimeSeconds, icon:String, score:int):
	var instance = Task.new()
	instance.taskName = ntaskName
	instance.nrOfTriggersNeeded = ntriggersNeeded
	instance.triggersNeeded = ntriggers	
	instance.isCompleted = false
	instance.taskTimeSeconds = ntaskTimeSeconds
	instance.taskIcon = icon
	instance.score = score
	return instance
