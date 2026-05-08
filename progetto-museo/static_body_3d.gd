extends StaticBody3D

signal parola_confermata(testo_inserito)

@onready var schermo = $Label3D 
@export var giocatore: CharacterBody3D 

var modalita_scrittura = false
var parola_attuale = ""

func on_clicked():
	modalita_scrittura = true
	parola_attuale = ""
	schermo.text = "_" 
	
	# Blocchiamo il giocatore
	if giocatore:
		giocatore.sta_scrivendo = true
		
	

func _input(event):
	if not modalita_scrittura:
		return
		
	if event is InputEventKey and event.pressed:
		
		# --- NUOVO: SE PREMIAMO ESC ---
		# --- SE PREMIAMO ESC ---
		if event.keycode == KEY_ESCAPE:
			modalita_scrittura = false
			
			# Rimuove il trattino "_" e lascia solo quello che stavi scrivendo
			schermo.text = parola_attuale 
			
			# Sblocchiamo il giocatore
			if giocatore:
				giocatore.sta_scrivendo = false
				
			# FORZIAMO LA COMPARSA DEL MOUSE DIRETTAMENTE DA QUI
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			return

		# "Mangiamo" tutti gli altri tasti per non far muovere il giocatore con WASD
		get_viewport().set_input_as_handled()
		
		# Se premiamo INVIO
		if event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER:
			if parola_attuale.length() > 0:
				modalita_scrittura = false
				parola_confermata.emit(parola_attuale)
				parola_attuale = ""
				schermo.text = "INSERITA"
				
				# Sblocchiamo il giocatore
				if giocatore:
					giocatore.sta_scrivendo = false
			
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
