class_name FryingPan extends CharacterBody2D

signal fryingpanmoved
var isSelected: bool = false
var restZones = []
var currentRestZone
var pancake : Node2D 
var count : int = 0
var signalSent:bool = false
@onready var frying_power_progress_bar: ProgressBar = $FryingPowerProgressBar
var currentFryingPanPower:float = 0.0
var minFryingPanPower:float = 0.0

func _ready():
	restZones = get_tree().get_nodes_in_group("returnZone")
	pancake = get_parent().get_node("Pancake")
	currentRestZone = restZones[0].global_position
	frying_power_progress_bar.visible = false


func _process(delta: float) -> void:
	if isSelected:
		$Sprite2D.scale = Vector2(1.20,1.20)		
	else:
		$Sprite2D.scale = Vector2(1.00,1.00)	

func _physics_process(delta):
	if isSelected:
		global_position = lerp(global_position, get_global_mouse_position(), 10*delta)
		_set_power_progress(20)					
	else:
		global_position = lerp(global_position, currentRestZone, 5*delta)
		_hide_power_progress()
		
		

		
func _input(event):
	if event is InputEventMouseButton:		
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:			
			isSelected = true
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			isSelected = false
			fryingpanmoved.emit(currentFryingPanPower)
			#if !signalSent:				
			#fryingpanmoved.emit(currentFryingPanPower)
			#	signalSent = true
			
			

func _on_mouse_entered() -> void:	
	$Sprite2D.scale = Vector2(1.20,1.20)

func _on_mouse_exited() -> void:	
	$Sprite2D.scale = Vector2(1.00,1.00)	
	
func _set_power_progress(newvalue):
	if (!frying_power_progress_bar.visible):
		frying_power_progress_bar.value = frying_power_progress_bar.min_value
		currentFryingPanPower = frying_power_progress_bar.min_value
		frying_power_progress_bar.visible = true
		
	currentFryingPanPower += newvalue
	frying_power_progress_bar.value = currentFryingPanPower

func _hide_power_progress():
	if (frying_power_progress_bar.visible):		
		frying_power_progress_bar.visible = false
		frying_power_progress_bar.value = frying_power_progress_bar.min_value
		currentFryingPanPower = frying_power_progress_bar.min_value
