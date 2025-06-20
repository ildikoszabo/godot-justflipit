extends Panel

func _ready():
	setBackground(Color.TRANSPARENT)

func setBackground(newColor):
	var style_box: StyleBoxFlat = get_theme_stylebox("panel")
	# Create a new StyleBoxFlat (or use an existing one)
	var new_style_box = StyleBoxFlat.new()
	new_style_box.bg_color = newColor  # Set
	# Apply the new style to the panel
	add_theme_stylebox_override("panel", new_style_box)
