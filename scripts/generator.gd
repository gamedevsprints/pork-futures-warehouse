extends Node
# var autopen_count = 0
# var autopen_base_price = 100
# var autopen_growth_rate = 1.7
# var autopen_production = 8
# var buy_autopen_button_format_string = "Buy Autopen - %s contracts"


var count: int
var base_price: int
var growth_rate: float
var production_rate: int
var generator_name: String
var can_afford: bool

signal purchase_attempted(price: int)
signal affordability_updated(can_afford: bool)

func _init(init_base_price, init_growth_rate, init_production_rate, init_generator_name) -> void:
	count = 0
	base_price = init_base_price
	growth_rate = init_growth_rate
	production_rate = init_production_rate
	generator_name = init_generator_name
	can_afford = false
	
func generator_price():
	return int(base_price * (growth_rate) ** float(count))



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
