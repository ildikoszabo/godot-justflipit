extends AnimationPlayer
@onready var bottle: Area2D = $".."

func _ready() -> void:
	bottle.bottle.connect(_onBottleSignal)
	bottle.resetbottle.connect(onreset)
	play("RESET")
	
func _onBottleSignal(triggerSource:Globals.Triggers):
	play("bottle_up")

func onreset():
	play("RESET")


func _on_animation_finished(anim_name: StringName) -> void:
	play("RESET")
