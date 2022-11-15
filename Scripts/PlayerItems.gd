extends Sprite

export (String) var item_name
export (Array, String) var objects_to_interact


func can_interact_with_object(object_name: String) -> bool:
	return object_name in objects_to_interact
