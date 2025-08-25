extends Node
class_name Generator
# var autopen_count = 0
# var autopen_base_price = 100
# var autopen_growth_rate = 1.7
# var autopen_production = 8
# var buy_autopen_button_format_string = "Buy Autopen - %s contracts"
var generator_name_label: Label 
@onready var buy_button: Button = %BuyButton
@onready var count_label: Label = %CountLabel
@onready var cost_label: Label = %CostLabel

var has_been_visible = false


@export var count: int # :
	#set(value):
		#price = generator_price()
		
@export var base_price: int 	
var price: int
@export var growth_rate: float
@export var production_rate: int
@export var generator_name: String
@export var can_afford: bool
@export var unlock_score: int 
signal purchase_attempted(price: int, generator: Generator)
	
func generator_price():
	return int(base_price * (growth_rate) ** float(count))



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count = 0
	price = generator_price()
	generator_name_label = %GeneratorNameLabel
	generator_name_label.text = generator_name
	count_label.text = str(count)
	cost_label.text = str(price) + " contracts"
	self.visible = false
	


## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass


func buy():
	count += 1
	price = generator_price()
	count_label.text = str(count)
	_update_cost_label(price)
	
	
func _update_cost_label(price_: int):
	cost_label.text = str(price_) + " contracts"

func _update_affordability(score: int):
	can_afford = score >= generator_price()
	#buy_button.disabled = not can_afford  # why problem?
	if not can_afford:
		buy_button.modulate = Color("red")
	else:
		buy_button.modulate = Color("green")
	

func _update_visibility(score: int):
	if has_been_visible:
		return
	if score >= unlock_score:
		
		self.visible = true
		has_been_visible = true

func _on_buy_button_button_down() -> void:

	pass # Replace with function body.
	purchase_attempted.emit(price, self)
