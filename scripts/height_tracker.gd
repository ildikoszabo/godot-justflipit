extends Node2D

signal height_reached

var spawnPosition:Vector2
var pancakePosition:Vector2

@onready var green_zone: ColorRect = $HeightBar/GreenZone
@onready var height_bar: ColorRect = $HeightBar
@onready var height_arrow: Sprite2D = $HeightArrow
@onready var pancake_flat: Area2D = $"../PancakeFlat" #TODO change the reference type when the main creates the pancakre, or it needs to be reset properly
var max_const:float = 50000.0
var max_height_reached:float = max_const#which is actually min height because y decreases
var shouldTrack:bool = false
var sentSignal:bool = false
var greenzonenentered:bool = false
var redzoneentered:bool=false

func _ready() -> void:
	spawnPosition = height_arrow.position
	height_bar.visible = false
	height_arrow.visible = false	
	sentSignal = false
	#TO-DO set green zone randomly on height bar
	pancake_flat.pancake_position_changed.connect(_on_sibling_position_changed)
	pancake_flat.is_pancake_moving.connect(_on_is_pancake_moving)

func _physics_process(delta: float) -> void:
	if (!pancakePosition.is_equal_approx(global_position)):		
		_set_height_arrow_position(pancakePosition)
	
	#check only when coming down	
	#if (!shouldTrack && (max_height_reached != max_const && max_height_reached != 0.0 ) && (max_height_reached >= green_zone.global_position.y  && max_height_reached < green_zone.get_size().y)):
	if not shouldTrack and redzoneentered == false and greenzonenentered == true:
		if (sentSignal == false):
			#print("shouldTrack: "+str(shouldTrack) + "max_height_reached " + str(max_height_reached) + "sentSignal " + str(sentSignal))
			sentSignal = true
			height_reached.emit(Globals.Triggers.BarScore)
			print("green signal")
			
	
	if (!shouldTrack):
		#print("green zone start:" + str(green_zone.global_position.y)) max_height_reached >= green_zone.global_position.y 
		#print("max:" + str(max_height_reached))		
		#print("green zone end:" + str(green_zone.get_size().y))		
		_hide_all()
		

func _set_height_arrow_position(newPosition):
	if (height_bar.visible == false && height_arrow.visible == false):
		height_bar.visible = true
		height_arrow.visible = true
	
	height_arrow.global_position.y = newPosition.y	
	
	if (newPosition.y<max_height_reached):
		max_height_reached = newPosition.y

func _hide_all():
	height_bar.visible = false
	height_arrow.visible = false	
	max_height_reached = max_const	

func _on_sibling_position_changed(new_position):
	pancakePosition = new_position
	
func _on_is_pancake_moving(ismoving):	
	if (shouldTrack == false && ismoving == true):
		max_height_reached = max_const #reset counter
		sentSignal = false
		greenzonenentered =false
		redzoneentered=false
	
	shouldTrack = ismoving


func _on_green_zone_area_entered(area: Area2D) -> void:
	if area is PancakeFlat:		
		greenzonenentered = true


func _on_red_zone_area_entered(area: Area2D) -> void:
	if area is PancakeFlat:
		redzoneentered = true
