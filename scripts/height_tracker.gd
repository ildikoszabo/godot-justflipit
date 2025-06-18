extends Node2D

var spawnPosition:Vector2
var pancakePosition:Vector2

@onready var green_zone: ColorRect = $HeightBar/GreenZone
@onready var height_bar: ColorRect = $HeightBar
@onready var height_arrow: Sprite2D = $HeightArrow
@onready var pancake_flat: Area2D = $"../PancakeFlat" #TODO change the reference type when the main creates the pancakre, or it needs to be reset properly
var max_height_reached:float = 50000.0 #which is actually min height because y decreases
var shouldTrack:bool = false

func _ready() -> void:
	spawnPosition = height_arrow.position
	height_bar.visible = false
	height_arrow.visible = false	
	#TO-DO set green zone randomly on height bar
	pancake_flat.pancake_position_changed.connect(_on_sibling_position_changed)
	pancake_flat.is_pancake_moving.connect(_on_is_pancake_moving)

func _physics_process(delta: float) -> void:
	if (!pancakePosition.is_equal_approx(global_position)):		
		_set_height_arrow_position(pancakePosition)
		
	if (shouldTrack && max_height_reached <= green_zone.global_position.y && max_height_reached > green_zone.get_size().y ):
		print(max_height_reached)
		print(green_zone.global_position.y)
		print(green_zone.get_size().y)
	
	if (!shouldTrack):
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
	max_height_reached = 5000000.0

func _on_sibling_position_changed(new_position):
	pancakePosition = new_position
	
func _on_is_pancake_moving(ismoving):
	shouldTrack = ismoving
