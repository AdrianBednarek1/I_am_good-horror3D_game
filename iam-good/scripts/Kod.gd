extends Node

var pin : String

func postavi_pin(_pin : String) -> void:
	pin = _pin

func otkljucaj(_pin : String) -> bool:
	if !pin:
		return false
	var tocan_pin : bool = pin == _pin
	return tocan_pin
