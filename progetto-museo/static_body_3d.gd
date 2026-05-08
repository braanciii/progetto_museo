extends StaticBody3D

signal parola_confermata(testo_inserito)

@onready var schermo = $Label3D 
var modalita_scrittura = false
var parola_attuale = ""

func on_clicked():
	modalita_scrittura = true
	parola_attuale = ""
	schermo.text = "_" 
	print("Terminale attivato, scrivi una parola...")

func _unhandled_input(event):
	if not modalita_scrittura:
		return
		
	if event is InputEventKey and event.pressed:
		# TRUCCO MAGICO: "Mangia" l'input della tastiera!
		# In questo modo WASD non faranno muovere il giocatore finché scrivi.
		get_viewport().set_input_as_handled()
		
		# Se premiamo INVIO
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			# Evita di inviare parole vuote
			if parola_attuale.length() > 0:
				modalita_scrittura = false
				
				# 1. Inviamo la parola al GameManager
				parola_confermata.emit(parola_attuale)
				
				# 2. Resettiamo il testo del terminale facendolo scomparire!
				parola_attuale = ""
				schermo.text = "INSERITA" # Oppure metti "" per lasciarlo vuoto
			
		# Se premiamo CANCELLA (Backspace)
		elif event.keycode == KEY_BACKSPACE:
			if parola_attuale.length() > 0:
				parola_attuale = parola_attuale.substr(0, parola_attuale.length() - 1)
			schermo.text = parola_attuale + "_"
			
		# Altrimenti, aggiungiamo la lettera
		else:
			var carattere = String.chr(event.unicode).to_upper()
			if carattere >= "A" and carattere <= "Z":
				parola_attuale += carattere
				schermo.text = parola_attuale + "_"
