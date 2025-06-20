extends Area2D

signal fanpancake

var selected:bool = false
var pancakeinposition = false
var sentsignal = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	$AnimatedSprite2D.animation = &"standing"		

func _process(delta: float) -> void:	
	if selected:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	if $AnimatedSprite2D.is_playing() and pancakeinposition:
		if sentsignal == false:
			print("fan signal")
			fanpancake.emit(Globals.Triggers.Fan)
			sentsignal = true

func _on_mouse_entered() -> void:
	$AnimatedSprite2D.animation = &"moving"
	selected=true
	sentsignal = false


func _on_mouse_exited() -> void:
	$AnimatedSprite2D.animation = &"standing"
	$AnimatedSprite2D.stop()		
	selected=false
	sentsignal = false


func _on_area_entered(area: Area2D) -> void:
	if area is PancakeFlat:		
		pancakeinposition = true


func _on_area_exited(area: Area2D) -> void:
	if area is PancakeFlat:		
		pancakeinposition = false
		sentsignal = false
