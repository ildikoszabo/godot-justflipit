extends Node2D

@export var returnZonePosition:Vector2
@onready var frying_pan: FryingPan = $FryingPan
@onready var pancake_flat: Area2D = $PancakeFlat #should be instanciated
@onready var leveltimer: Timer = $Leveltimer
@onready var fall_fast: Sprite2D = $Icons/FallFast
@onready var flip_left: Sprite2D = $Icons/FlipLeft
@onready var flip_right: Sprite2D = $Icons/FlipRight
@onready var throw_high: Sprite2D = $Icons/ThrowHigh
@onready var height_tracker: Node2D = $HeightTracker


var currentLevel:String
var levels :Dictionary = {}
var levelTimer:int = 0

func _ready():
	frying_pan.fryingpanmoved.connect(_on_fryingpan_moved)
	height_tracker.height_reached.connect(onTriggerSignalReceived)
	create_levels()
	currentLevel = "level1"
	levelTimer = getLevelTime()
	#for levelTask in levels[currentLevel]:
		#item_list.add_item("Item 1")
		#item_list.add_icon_item(load("res://assets/art/ThrowHigh.png"), "Item 2")
		#var item = ItemList.Item.new()
		#item.set_icon(load("res://my_icon.png")) # Replace with your icon path
		#item.set_text("Item " + str(i))
		#item_list.add_item(item)
		#item_list.add_child(item)
	

func newGame():
	levelTimer = getLevelTime()	
	leveltimer.wait_time = levelTimer
	#show tasks



func _on_leveltimer_timeout() -> void:
	pass # Replace with function body.

func _on_fryingpan_moved(newspeed):
	pancake_flat._set_should_move(true,newspeed)	
	
func create_levels():
	var task1 = Task.create_task(Globals.TaskNames.ThrowHigh,1,[Globals.Triggers.BarScore], 10, throw_high)
	var task2 = Task.create_task(Globals.TaskNames.FlipLeft,1,[Globals.Triggers.Fan], 10, flip_left)
	levels["level1"] = [task1]
	levels["level2"] = [task1, task2]

func getLevelTime():
	var time = 0
	var levelTasks = levels[currentLevel]
	for levelTask in levelTasks:
		time += levelTask.taskTimeSeconds
	return time
		
func onChangeLevel():
	levelTimer = getLevelTime()

func isTaskNotCompleted(task):
	return task.isCompleted == false
	
func isSameArray(array1, array2):
	if array1.size() != array2.size():
		return false
	
	for i in range(array1.size()):
		if array1[i] != array2[i]:
			return false
	return true


func onTriggerSignalReceived(triggerSource:Globals.Triggers):
	var currentTasks = levels[currentLevel]
	var validTaskId = currentTasks.find_custom(isTaskNotCompleted.bind())
	if (validTaskId != -1):
		var validTask = currentTasks[validTaskId]
		if !validTask.triggersReceived.has(triggerSource):
			validTask.triggersReceived.append(triggerSource)			
			if (validTask.triggersReceived.size() == validTask.nrOfTriggersNeeded and isSameArray(validTask.triggersNeeded, validTask.triggersReceived)):
				validTask.isCompleted = true;
