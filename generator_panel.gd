extends Node
class_name Generator

@onready var generator_name_label: Label = %GeneratorNameLabel
@onready var buy_button: Button = %BuyButton
@onready var count_label: Label = %CountLabel
@onready var cost_label: Label = %CostLabel

var has_been_visible = false

var count: int
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

func _ready() -> void:
	count = 0
	price = generator_price()
	generator_name_label.text = generator_name
	var plural = "s" if count != 1 else ""
	count_label.text = str(count) + " " + generator_name + plural
	cost_label.text = str(price) + " contracts"
	self.visible = false

func buy():
	count += 1
	price = generator_price()
	var plural = "s" if count != 1 else ""
	count_label.text = str(count) + " " + generator_name + plural
	_update_cost_label(price)
	
	
func _update_cost_label(price_: int):
	cost_label.text = str(price_) + " contracts"

func _update_affordability(score: int):
	can_afford = score >= generator_price()
	if can_afford:
		buy_button.modulate = Color("green")
	else:
		buy_button.modulate = Color("red")	
	

func _update_visibility(score: int):
	if has_been_visible:
		return
	if score >= unlock_score:
		self.visible = true
		has_been_visible = true

func _on_buy_button_button_down() -> void:
	purchase_attempted.emit(price, self)
