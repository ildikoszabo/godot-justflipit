extends Marker2D

func _ready() -> void:
	global_position = get_parent().returnZonePosition
