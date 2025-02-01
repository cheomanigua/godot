class_name Product
extends Resource

var name: String
var base_price: float
var market_price: float
var stock: int
var demand: float

func _ready():
	# Default product setup
	name = "Wheat"
	base_price = 10.0
	market_price = base_price
	stock = 0
