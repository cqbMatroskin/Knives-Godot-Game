extends Node

enum LOCATIONS { START, GAME, SHOP }

signal location_changed(location: LOCATIONS)
signal game_over
signal points_changed(points: int)
signal knives_amount_changed(amount: int)
signal stage_changed(stage: Stage)
