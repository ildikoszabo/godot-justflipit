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
@onready var task_count_label: Label = $TaskDisplay/ColorRect/TaskCountLabel
@onready var task_icon: TextureRect = $TaskDisplay/ColorRect/TaskIconPanel/TaskIcon
@onready var task_icon_panel: Panel = $TaskDisplay/ColorRect/TaskIconPanel
@onready var blank_background: Sprite2D = $BlankBackground
@onready var background: Sprite2D = $background
@onready var task_display: Control = $TaskDisplay
@onready var game_label: Label = $GameLabel
@onready var start_game_button: Button = $StartGameButton
@onready var time_panel: Control = $TimePanel
@onready var level_time: Label = $TimePanel/LevelTime
@onready var failed_level_panel: Control = $FailedLevelPanel
@onready var fan: Area2D = $Fan
@onready var FailedLevelPanellabel: Label = $FailedLevelPanel/Label
@onready var gameoverlabel: Label = $FailedLevelPanel/gameoverlabel
@onready var score_label: Label = $ScorePanel/ScoreLabel
@onready var score_panel: Control = $ScorePanel
@onready var finalscore: Label = $FailedLevelPanel/finalscore
@onready var bottle: Area2D = $Bottle

var score=0
var currentLevel:String
var levels :Dictionary = {}
var nrOfTasksCompleted:int=0
var nrOfTasksNeeded:int=0
var gamestarted=false

func _ready():
	frying_pan.fryingpanmoved.connect(_on_fryingpan_moved)
	height_tracker.height_reached.connect(onTriggerSignalReceived)
	fan.fanpancake.connect(onTriggerSignalReceived)
	bottle.bottle.connect(onTriggerSignalReceived)
	create_levels()
	currentLevel = "level1"
	failed_level_panel.hide()
	game_label.show()
	start_game_button.show()
	setScene(false)	 #MOVEIT TO FALSE MOVE IT TO FALSE MOVE IT TO FAAAAAAAAAAAAAALLLLLLLLLLSE

	"""	levelTimer = getLevelTime()
	setLevelText()
	setCurrentTaskIcon()
	for levelTask in levels[currentLevel]:"""
		#item_list.add_item("Item 1")
		#item_list.add_icon_item(load("res://assets/art/ThrowHigh.png"), "Item 2")
		#var item = ItemList.Item.new()
		#item.set_icon(load("res://my_icon.png")) # Replace with your icon path
		#item.set_text("Item " + str(i))
		#item_list.add_item(item)
		#item_list.add_child(item)
	
func setScene(visible):	
	if visible == true:
		blank_background.hide()		
		time_panel.show()
		background.show()
		frying_pan.show()
		pancake_flat.show()
		task_display.show()
		fan.show()
		score_panel.show()
		bottle.show()
		gamestarted = true
	else:
		blank_background.show()		
		time_panel.hide()
		background.hide()
		frying_pan.hide()
		pancake_flat.hide()
		task_display.hide()
		fan.hide()
		score_panel.hide()
		bottle.hide()
		gamestarted = false
	

func _process(delta: float) -> void:
	if gamestarted:
		score_label.text = str(score)
		if not leveltimer.is_stopped():
			setLevelTIme(roundf(leveltimer.time_left))
		
		setLevelText()
		#setCurrentTaskIcon()
		if levels[currentLevel].size() == nrOfTasksCompleted:
			print("done") #go to next level	
			score += getLevelScore()
			score_label.text = str(score)
			changelevel()


func newGame():
	currentLevel = "level1"
	resetLevels()
	var levelTime = getLevelTime()	
	leveltimer.wait_time = levelTime
	setLevelTIme(levelTime)
	leveltimer.start()
	#show tasks
	nrOfTasksCompleted = 0
	nrOfTasksNeeded = 0
	setLevelText()
	setCurrentTaskIcon()
	gamestarted = true
	
func newLevel(level):
	currentLevel = level
	resetCertainLevel(level)	
	var levelTime = getLevelTime()	
	leveltimer.wait_time = levelTime
	setLevelTIme(levelTime)
	leveltimer.start()
	#show tasks
	nrOfTasksCompleted = 0
	nrOfTasksNeeded = 0
	setLevelText()
	setCurrentTaskIcon()
	gamestarted = true

func changelevel():
	var nextlevel = _getNextLevel()
	if nextlevel == "complete":
		ongameover()
	else:
		newLevel(nextlevel)	

func resetLevels():
	for level in levels:
		for task in levels[level]:
			task.isCompleted = false
			task.triggersReceived.clear()

func resetCertainLevel(levelToReset):
	pancake_flat.resetPosition()
	var leveltasks = levels[levelToReset]
	for task in leveltasks:
		task.isCompleted = false
		task.triggersReceived.clear()

func getLevelScore():
	var count = 0
	var levelTasks = levels[currentLevel]
	for levelTask in levelTasks:
		count += levelTask.score
	return count

func setLevelTIme(time):
	level_time.text = str(time)

func setLevelText():
	nrOfTasksCompleted = getNrOfTasksCompletedOnLevel(currentLevel)
	nrOfTasksNeeded = levels[currentLevel].size()
	task_count_label.text = "Tasks " + str(nrOfTasksCompleted)+ "/"+str(nrOfTasksNeeded)

func setCurrentTaskIcon():
	var currentTasks = levels[currentLevel]
	var nextId = currentTasks.find_custom(isTaskNotCompleted.bind())
	if (nextId != -1):
		var image = Image.new()
		var image_path = currentTasks[nextId].taskIcon #"res://path/to/your/image.png"  Replace with your image path
		var err = image.load(image_path)
		var texture = ImageTexture.create_from_image(image)
		setTaskIconTransparent()
		task_icon.texture = texture
	
func setTaskIconCompleted():
	task_icon_panel.setBackground(Color.GREEN)
	var tween = get_tree().create_tween()
	tween.tween_property(task_icon_panel, "scale", Vector2(1.25,1.25), 0.5)
	tween.tween_property(task_icon_panel, "scale", Vector2(1.0,1.0), 0.5)	

func setTaskIconTransparent():
	task_icon_panel.setBackground(Color.TRANSPARENT)

func _on_leveltimer_timeout() -> void:
	leveltimer.stop()
	FailedLevelPanellabel.show()
	gameoverlabel.hide()
	finalscore.hide()
	failed_level_panel.show()
	gamestarted = false
	setScene(false)

func ongameover():
	leveltimer.stop()
	FailedLevelPanellabel.hide()
	gameoverlabel.show()
	finalscore.text = "Final Score: " + str(score)
	finalscore.show()
	failed_level_panel.show()
	gamestarted = false
	setScene(false)

func _on_fryingpan_moved(newspeed):
	pancake_flat._set_should_move(true,newspeed)	
	
func create_levels():
	var task1 = Task.create_task(Globals.TaskNames.ThrowHigh,1,[Globals.Triggers.BarScore], 10,  "res://assets/art/ThrowHigh.png",5)
	var task2 = Task.create_task(Globals.TaskNames.FlipLeft,1,[Globals.Triggers.Fan], 10,   "res://assets/art/FlipLeft.png",7)
	var task3 = Task.create_task(Globals.TaskNames.FallFast,1,[Globals.Triggers.Sirup], 8,   "res://assets/art/FallFast.png",9)
	levels["level1"] = [task1]
	levels["level2"] = [task1, task2]
	levels["level3"] = [task3]
	levels["level4"] = [task2, task1, task2]
	levels["level5"] = [task1, task3, task2, task1]
	levels["level6"] = [task3, task3, task2, task1]

func getLevelTime():
	var time = 0
	var levelTasks = levels[currentLevel]
	for levelTask in levelTasks:
		time += levelTask.taskTimeSeconds
	return time

func isTaskNotCompleted(task):
	return task.isCompleted == false
	
func isSameArray(array1, array2):
	if array1.size() != array2.size():
		return false
	
	for i in range(array1.size()):
		if array1[i] != array2[i]:
			return false
	return true

func getNrOfTasksCompletedOnLevel(checklevel):
	var count = 0
	var level = levels[checklevel]
	for task in level:
		if task.isCompleted == true:
			count +=1
	return count

func onTriggerSignalReceived(triggerSource:Globals.Triggers):
	var currentTasks = levels[currentLevel]
	var validTaskId = currentTasks.find_custom(isTaskNotCompleted.bind())
	if (validTaskId != -1):
		var validTask = currentTasks[validTaskId]
		if !validTask.triggersReceived.has(triggerSource):
			validTask.triggersReceived.append(triggerSource)			
			if (validTask.triggersReceived.size() == validTask.nrOfTriggersNeeded and isSameArray(validTask.triggersNeeded, validTask.triggersReceived)):
				validTask.isCompleted = true;
				setTaskIconCompleted()
				setCurrentTaskIcon()
	
	


func _on_start_game_button_pressed() -> void:
	score = 0
	game_label.hide()
	start_game_button.hide()
	setScene(true)	
	newGame()


func _on_retry_level_button_pressed() -> void:
	var currenttasks = levels[currentLevel]
	if currenttasks.all(func(element): return element.isCompleted):		
			score -= getLevelScore()
	setTaskIconTransparent()
	failed_level_panel.hide()
	setScene(true)	
	newLevel(currentLevel)


func _on_restart_game_button_pressed() -> void:
	setTaskIconTransparent()
	failed_level_panel.hide()
	_on_start_game_button_pressed()
	
	
func _getNextLevel():
	if currentLevel == "level1":
		return "level2"
	if currentLevel == "level2":
		return "level3"
	if currentLevel == "level3":
		return "level4"
	if currentLevel == "level4":
		return "level5"
	if currentLevel == "level5":
		return "level6"
	if currentLevel == "level6":
		return "complete"
