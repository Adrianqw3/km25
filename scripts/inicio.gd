extends Node2D

@onready var inicio: TextureButton = $inicio
@onready var salida: TextureButton = $salida
@onready var opciones: TextureButton = $opciones

func _ready() -> void:
	inicio.pressed.connect(_on_inicio_pressed)
	salida.pressed.connect(_on_salida_pressed)
	opciones.pressed.connect(_on_opciones_pressed)
	
func _on_inicio_pressed():
	print('Precionaste incio')
	MainScript._start_work_cycle()
	
func _on_salida_pressed():
	print("Presionastes salida")
	get_tree().quit()

func _on_opciones_pressed():
	print("Opciones")
	
