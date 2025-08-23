extends Node2D

var score = 0
@onready var rich_text_label: RichTextLabel = $RichTextLabel


func _on_button_button_down() -> void:
	increment_score()


func increment_score():
	score += 1
	rich_text_label.text = str(score)
