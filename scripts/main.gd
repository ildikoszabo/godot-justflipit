extends Node2D

@export var returnZonePosition:Vector2

enum States {
	StandBy,
	Cooking,
	Flip,
	Done,
	Ready,
	Burned
}
