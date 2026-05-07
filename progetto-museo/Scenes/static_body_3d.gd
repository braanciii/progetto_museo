extends StaticBody3D

signal inizia_cifratura # Questo segnale avviserà il gestore del gioco

func on_clicked():
	print("Bottone premuto!")
	emit_signal("inizia_cifratura")
	# Qui puoi aggiungere una piccola animazione del bottone che va giù e su usando un Tween
