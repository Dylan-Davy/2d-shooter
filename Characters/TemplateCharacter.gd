extends KinematicBody2D

const MAX_SPEED = 300
var motion = Vector2()
var health = 100
var physical_res
var energy_res
var plasma_res
var resistance
var piercing_res

func damage_taken(damage):
	health -= damage * (1 - 0.01 * resistance)

func resistance_type(damage_type):
	if damage_type == "physical":
		resistance = physical_res
	elif damage_type == "energy":
		resistance = energy_res
	elif damage_type == "plasma":
		resistance = plasma_res
