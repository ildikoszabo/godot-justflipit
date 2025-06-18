extends Node2D

@export var returnZonePosition:Vector2
@onready var frying_pan: FryingPan = $FryingPan
@onready var pancake_flat: Area2D = $PancakeFlat #should be instanciated


enum States {
	StandBy,
	Cooking,
	Flip,
	Done,
	Ready,
	Burned
}

func _ready():
	frying_pan.fryingpanmoved.connect(_on_fryingpan_moved)

func _on_fryingpan_moved(newspeed):
	pancake_flat._set_should_move(true,newspeed)	
