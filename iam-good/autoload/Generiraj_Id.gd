extends Node

func Novi_Id()-> String:
	return str(Time.get_ticks_usec()) + str(randi()) 
