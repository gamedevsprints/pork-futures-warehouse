extends Node2D

var debug = false

var score = 0
@onready var score_label: RichTextLabel = %ScoreLabel
@onready var generators_container: VBoxContainer = %Generators
var generators: Array[Generator]

func _ready() -> void:
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


func _on_contract_button_button_down() -> void:
	score += 1
	score_label.text = str(score) + " contracts"
	for generator in generators:
		generator._update_affordability(score)
		generator._update_visibility(score)


func _handle_purchase_attempted(price: int, generator: Generator):
	if score >= price:
		score -= price
		score_label.text = str(score) + " contracts"
		generator.buy()
		for generator_ in generators:
			generator_._update_affordability(score)
			generator._update_visibility(score)


func _on_production_timer_timeout() -> void:
	for generator in generators:
		score += generator.count * generator.production_rate
	score_label.text = str(score) + " contracts"
	for generator in generators:
		generator._update_affordability(score)
		generator._update_visibility(score)


func _on_debug_button_button_down() -> void:
	score += int(%DebugTextEdit.text)
	score_label.text = str(score) + " contracts"
