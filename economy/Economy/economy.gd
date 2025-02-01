extends Node

var cities : Array = []
var products : Array = []
var products_base_price = { "Wheat": 2.0, "Corn": 2.0, "Fruit": 3.0, "Wine": 6.0, "Gold": 20.0}
#var cities_array: Array = ["Barcelona", "Tarragona", "Valencia", "Perpiñan", "Marsella", "Livorno", "Napoles", "Venecia", "Cartagena", "Genova"]
#var products_array: Array = ["Wheat", "Corn", "Fruit", "Wine", "Olives:", "Fish", "Wool", "Iron", "Gold", "Silver"]
var cities_array: Array = ["Barcelona", "Tarragona", "Valencia", "Perpiñan"]
func _ready():
	# Create 10 cities and 10 products
	for i in cities_array.size():
		var city = City.new()
		city.cname = cities_array[i]
		cities.append(city)
	for i in products_base_price.size():
		var product = Product.new()
		product.name = products_base_price.keys()[i]
		product.base_price = products_base_price.values()[i]
		#product.base_price = randf_range(5.0, 20.0)
		products.append(product)
	
	for city in cities:
		print("\n", city.cname)
		print("Product\t\tStock\tDemand\tPrice")
		for product in products:
			# Update demand and inventory
			city.demand[product.name] = randf_range(0.5, 2.0)  # Random demand fluctuation
			city.inventory[product.name] = int(randf_range(0, 1000))  # Random stock
			city.price_modifiers[product.name] = 1.0
			product.stock = city.inventory[product.name]
			product.demand = city.demand[product.name]
			# Recalculate prices based on supply and demand
			product.market_price = calculate_price(city, product)
			print("%s\t\t%d\t\t%0.2f\t%0.2f" % [product.name, product.stock, product.demand, product.market_price])


func _process(_delta):
	#Simulate economy behavior over time
	for city in cities:
		for product in products:
			# Update demand and inventory
			city.demand[product.name] = randf_range(0.5, 2.0)  # Random demand fluctuation
			city.inventory[product.name] = int(randf_range(0, 1000))  # Random stock
			product.stock = city.inventory[product.name]
			
			# Recalculate prices based on supply and demand
			product.market_price = calculate_price(city, product)

	# Optionally, trigger trade events between cities every few seconds
	if randf_range(0, 1) < 0.1:
		var city1 = cities[int(randf_range(0, cities.size()))]
		var city2 = cities[int(randf_range(0, cities.size()))]
		var product_to_trade = products[int(randf_range(0, products.size()))]
		trade(city1, city2, product_to_trade.name, int(randf_range(10, 100)))


func calculate_price(city: City, product: Product) -> float:
	var base_price = product.base_price
	var supply = city.inventory.get(product.name, 0)
	var demand = city.demand.get(product.name, 1.0)

	# Modify the price based on supply and demand
	var price_factor = 1.0 + ((demand - 1.0) * 0.2)  # Increase price with demand
	price_factor -= (supply / 1000.0)  # Decrease price with increased supply

	return base_price * price_factor


func trade(from_city: City, to_city: City, product_name: String, quantity: int):
	var product_from = from_city.inventory.get(product_name, 0)
	#var product_to = to_city.inventory.get(product_name, 0)

	if product_from >= quantity:
		var price = calculate_price(from_city, Product.new()) # Calculate price for the product
		var total_cost = price * quantity
		
		##Update inventories after trade
		from_city.inventory[product_name] -= quantity
		to_city.inventory[product_name] += quantity
		#
		###Optionally adjust prices based on trade volume
		from_city.price_modifiers[product_name] += 0.05  # Adjust price modifiers with trade
		to_city.price_modifiers[product_name] -= 0.05
		print("%s: %s" % [from_city.cname, from_city.price_modifiers])
		
		return total_cost
	else:
		return -1  # Not enough stock
