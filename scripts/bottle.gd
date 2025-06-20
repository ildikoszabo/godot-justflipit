extends Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

signal bottle
signal resetbottle

var selected:bool = false
var pancakeinposition = false
var sentsignal = false
@onready var pancake_flat: PancakeFlat = $"../PancakeFlat"

func _ready() -> void:
	pancake_flat.is_pancake_moving.connect(onpancakemoving)

func _process(delta: float) -> void:	
	if selected and sentsignal == false and pancakeinposition:
		#play("bottle_up")
		print("bttle signal")
		sentsignal = true
		resetbottle.emit()
		bottle.emit(Globals.Triggers.Sirup)

func _on_mouse_entered() -> void:
	$Sprite2D.scale = Vector2(1.20,1.20)
	selected=true
	sentsignal = false
	
func onpancakemoving(shouldmove):
	pancakeinposition = shouldmove

func _on_mouse_exited() -> void:
	$Sprite2D.scale = Vector2(1.00,1.00)
	selected=false
	sentsignal = false
