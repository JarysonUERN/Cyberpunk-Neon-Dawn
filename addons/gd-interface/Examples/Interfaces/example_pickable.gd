class_name ExamplePickable extends Interface



func _init(implementation: Callable) -> void:
	contract = implementation
	type = InterfaceType.new(self.get_class())
	types[self.get_class()] = type


func get_class() -> String:
	return "ExamplePickable"



static func get_interface_type() -> InterfaceType:
	return Interface.types["ExamplePickable"]
