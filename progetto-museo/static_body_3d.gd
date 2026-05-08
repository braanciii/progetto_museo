extends StaticBody3D

# Questo segnale avviserà il GameManager inviandogli direttamente la parola!
signal parola_confermata(testo_inserito)

@onready var schermo = $Label3D # Assicurati che il nome sia giusto
var modalita_scrittura = false
var parola_attuale = ""

func on_clicked():
	# Quando il laser ci clicca sopra, attiviamo la modalità scrittura
	modalita_scrittura = true
	parola_attuale = ""
	schermo.text = "_" # Mostra un cursore finto per far capire che sta scrivendo
	print("Terminale attivato, scrivi una parola...")

func _unhandled_input(event):
	# Se non stiamo scrivendo, ignora i tasti
	if not modalita_scrittura:
		return
		
	# Se premiamo un tasto sulla tastiera
	if event is InputEventKey and event.pressed:
		
		# Se premiamo INVIO
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			modalita_scrittura = false
			schermo.text = parola_attuale
			# Inviamo la parola al GameManager!
			parola_confermata.emit(parola_attuale)
			
		# Se premiamo CANCELLA (Backspace)
		elif event.keycode == KEY_BACKSPACE:
			if parola_attuale.length() > 0:
				parola_attuale = parola_attuale.substr(0, parola_attuale.length() - 1)
			schermo.text = parola_attuale + "_"
			
		# Altrimenti, leggiamo la lettera digitata
		else:
			var carattere = String.chr(event.unicode).to_upper()
			# Accettiamo solo lettere dalla A alla Z
			if carattere >= "A" and carattere <= "Z":
				parola_attuale += carattere
				schermo.text = parola_attuale + "_"
