extends Node

#class City:
	#var name: String = ""
	#var production: Dictionary = {}  # stores how much of each product a city produces
	#var demand: Dictionary = {}  # stores demand for each product in the city
	#var stock: Dictionary = {}  # stores stock of products in each city
	#var price: Dictionary = {}  # stores prices for each product
	#func _init(iname, iproduction, idemand, istock, iprice) -> void:
		#self.name = iname
		#self.production = iproduction
		#self.demand = idemand
		#self.stock = istock
		#self.price = iprice

#var cities: Array = ["Barcelona", "Tarragona", "Valencia", "Perpiñan", "Marsella", "Livorno", "Napoles", "Venecia", "Cartagena", "Genova"]
#var products: Array = ["Wheat", "Corn", "Fruit", "Wine", "Oil", "Fish", "Wool", "Iron", "Gold", "Silver"]
var cities: Array = ["Barcelona", "Tarragona"]
var products: Array = ["Wheat", "Corn"]
var Ciudad: Dictionary
# Main simulation loop
func _ready():
	for city in cities:
		City[city] = "hola"
		print(Ciudad)
		#cities[city] = inst_to_dict(City.new(cities[city], {}, {}, {}, {}))
		#print(cities)
		#print(cities[city])
		#print("%s:" % [cities[city].values()[2]])
		#print("Product\t\tProduction\tDemand\tStock\tPrice")
		#print(products[city])
		for product in products.size():
			#cities[city][str(cities[city].keys()[3])] = {products[product] : randi_range(0, 100)}
			#cities[city][cities[city].keys()[3]] = {products[product] : randi_range(0, 100)}
			pass
			#cities[city][str(cities[city].keys()[4])] = {products[product] : randi_range(50, 500)}
			#cities[city][str(cities[city].keys()[5])] = {products[product] : randi_range(10, 1000)}
			#cities[city][str(cities[city].keys()[6])] = {products[product] : randf_range(5, 10)}
			#print(cities[city])
			#print("%s:\t\t%d\t\t\t%d\t\t%d\t\t%0.2f" % [cities[city].values()[3].keys()[0], 
			#cities[city].values()[3].values()[0], 
			#cities[city].values()[4].values()[0],
			#cities[city].values()[5].values()[0],
			#cities[city].values()[6].values()[0]])
	# Outer dictionary
	#var city = {
		#"name": "Barcelona"
	#}
#
	## Inner dictionary
	#var production = {
		#"Wheat": 4,
		#"Wine": 6,
	#}
#
	## Add the inner dictionary into the outer dictionary under a key
	#city["production"] = production
#
	## Accessing the inner dictionary via the outer dictionary
	#print(city["production"]["Wheat"])  # Output: value1
	#print(city)
	#print(cities[0])
	#initialize_data()  # Initialize cities and products
	#for step in range(10):  # Simulate for 10 steps (you can adjust this)
		#print("Step %d" % step)
		#for i in range(cities.size()):
			#for j in range(i + 1, cities.size()):
				#trade_between_cities(cities[i], cities[j])
		#simulate_economy()  # Calculate and print the wealth of each city

# Initialize city data for products
func initialize_data():
	for city in cities:
		for product in products:
			cities[city][str(cities[city].keys()[product])] = {products[product] : randi_range(50, 500)}  # Random production quantity
			city.demand[product] = randf_range(50, 500)  # Random demand quantity
			city.stock[product] = randf_range(100, 1000)  # Random stock
			city.price[product] = randf_range(5, 100)  # Random price between 5 and 100
			#city.production[product] = randf_range(50, 500)  # Random production quantity
			#city.demand[product] = randf_range(50, 500)  # Random demand quantity
			#city.stock[product] = randf_range(100, 1000)  # Random stock
			#city.price[product] = randf_range(5, 100)  # Random price between 5 and 100

# Function to adjust price based on supply and demand
func adjust_price(city: City, product: String):
	var supply = city.stock[product]
	var demand = city.demand[product]

	# Simple price adjustment based on supply and demand
	if supply > demand:
		# If supply exceeds demand, price drops
		city.price[product] -= city.price[product] * 0.05  # Decrease by 5%
	elif demand > supply:
		# If demand exceeds supply, price rises
		city.price[product] += city.price[product] * 0.05  # Increase by 5%

	# Ensure price stays within reasonable bounds
	city.price[product] = clamp(city.price[product], 5, 200)

# Function to simulate trade between two cities
#func trade_between_cities(city1: City, city2: City):
	#for product in products:
		#if city1.stock[product] > 0 and city2.demand[product] > 0:
			## Calculate the trade amount
			#trade_amount = min(city1.stock[product], city2.demand[product])
			#
			## Transfer goods from city1 to city2
			#city1.stock[product] -= trade_amount
			#city2.stock[product] += trade_amount
			#
			## Adjust prices after trade
			#adjust_price(city1, product)
			#adjust_price(city2, product)

# Function to calculate wealth of each city
func calculate_wealth(city: City) -> float:
	var wealth = 0.0
	for product in products:
		wealth += city.stock[product] * city.price[product]  # Wealth is stock * price of each product
	return wealth

# Simulate the economy after trade
func simulate_economy():
	for city in cities:
		var wealth = calculate_wealth(city)
		print("City: %s, Wealth: %.2f" % [city.name, wealth])
