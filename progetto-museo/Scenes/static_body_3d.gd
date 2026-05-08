extends StaticBody3D

signal bottone_premuto # Questo segnale avviserà il gestore del gioco

func on_clicked():
	print("Bottone premuto!")
	bottone_premuto.emit()
	# Qui puoi aggiungere una piccola animazione del bottone che va giù e su usando un Tween
