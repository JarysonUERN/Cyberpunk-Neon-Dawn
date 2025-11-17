extends MeshInstance3D

var interactable: ExampleInteractable = ExampleInteractable.new(interact)

func interact(color: Color, message: String) -> void:
	(get_active_material(0) as StandardMaterial3D).albedo_color = color
	print_rich("[color=yellow]", "From Interactable object: ", message)
