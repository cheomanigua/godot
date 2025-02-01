class_name City
extends Node

var cname: String
var inventory : Dictionary = {} # Key: Product name, Value: Quantity
var demand : Dictionary = {} # Key: Product name, Value: Demand factor
var price_modifiers : Dictionary = {} # Key: Product name, Value: Price modifier
var city_id: int

func _ready():
	# Initialize with some dummy data
	cname = "City A"
	inventory = {"Wheat": 1000, "Iron": 500, "Cloth": 200}
	demand = {"Wheat": 1.2, "Iron": 0.8, "Cloth": 1.0}
	price_modifiers = {"Wheat": 1.0, "Iron": 1.0, "Cloth": 1.0}
	city_id = 1
