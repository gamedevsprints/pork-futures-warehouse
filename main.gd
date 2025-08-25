extends Node2D

var debug = true

var score = 0
var clerks: int = 0
var base_clerk_price := 10
var other_thing = 1.5
var clerk_production_rate_per_second = 1
@onready var rich_text_label: RichTextLabel = $RichTextLabel
@onready var buy_cerk_button: Button = $Control/BuyCerkButton
var clerk_button_message_format_string: String = "Buy Clerk - %s contracts"

var autopen_count = 0
var autopen_base_price = 100
var autopen_growth_rate = 1.7
var autopen_production = 8
var buy_autopen_button_format_string = "Buy Autopen - %s contracts"
@onready var buy_autopen_button: Button = $Control/BuyAutopenButton
@onready var generators_container: VBoxContainer = %Generators
var generators: Array[Generator]

func _ready() -> void:
	buy_cerk_button.text = clerk_button_message_format_string % str(clerk_price()) 
	buy_autopen_button.text = buy_autopen_button_format_string % str(autopen_price())  # hid the at first?
	for generator in generators_container.get_children():
		generators.append(generator)
	for generator in generators:
		generator._update_affordability(score)
		generator._update_visibility(score)
		generator.purchase_attempted.connect(_handle_purchase_attempted)
	if debug:
		%DebugPanel.visible = true
	else:
		%DebugPanel.visible = false
		
			

func _on_button_button_down() -> void:
	increment_score()
	for generator in generators:
		generator._update_affordability(score)
		generator._update_visibility(score)

func _handle_purchase_attempted(price: int, generator: Generator):
	if score >= price:
		score -= price
		rich_text_label.text = str(score) + " contracts"
		generator.buy()
		for generator_ in generators:
			generator_._update_affordability(score)
			generator._update_visibility(score)
	else:
		pass
	
	
	
func increment_score():
	score += 1
	rich_text_label.text = str(score) + " contracts"


func clerk_price():
	return int(base_clerk_price * (other_thing) ** float(clerks))

func autopen_price():
	return int(autopen_base_price * (autopen_growth_rate) ** float(autopen_count))

func _on_buy_cerk_button_button_down() -> void:
	if score - clerk_price() < 0:
		return
	score -= clerk_price()
	clerks += 1
	buy_cerk_button.text = clerk_button_message_format_string % str(clerk_price())
	rich_text_label.text = str(score) + " contracts"



func _on_buy_autopen_button_button_down() -> void:
	if score - autopen_price() < 0:
		return
	score -= autopen_price()
	autopen_count += 1
	buy_autopen_button.text = buy_autopen_button_format_string % str(autopen_price())
	rich_text_label.text = str(score) + " contracts"




func _on_production_timer_timeout() -> void:
	#score += clerks * clerk_production_rate_per_second
	#score += autopen_count * autopen_production
	
	for generator in generators:
		score += generator.count * generator.production_rate
	
	for generator in generators:
		generator._update_affordability(score)
		generator._update_visibility(score)
	rich_text_label.text = str(score) + " contracts"


func _on_debug_button_button_down() -> void:
	score += int(%DebugTextEdit.text)
	
