extends Node3D

@export var bottone: StaticBody3D
@export var punto_spawn: Node3D
@export var terminale: StaticBody3D

var modelli_lettere = {
	"A": preload("res://oggetti/cifrario cesare/lettere/A/A.tscn"), 
	"B": preload("res://oggetti/cifrario cesare/lettere/B/B.tscn"), 
	"C": preload("res://oggetti/cifrario cesare/lettere/C/C.tscn"), 
	"D": preload("res://oggetti/cifrario cesare/lettere/D/D.tscn"), 
	"E": preload("res://oggetti/cifrario cesare/lettere/E/E.tscn"), 
	"F": preload("res://oggetti/cifrario cesare/lettere/F/F.tscn"), 
	"G": preload("res://oggetti/cifrario cesare/lettere/G/G.tscn"), 
	"H": preload("res://oggetti/cifrario cesare/lettere/H/H.tscn"), 
	"I": preload("res://oggetti/cifrario cesare/lettere/I/I.tscn"), 
	"J": preload("res://oggetti/cifrario cesare/lettere/J/J.tscn"), 
	"K": preload("res://oggetti/cifrario cesare/lettere/K/K.tscn"), 
	"L": preload("res://oggetti/cifrario cesare/lettere/L/L.tscn"), 
	"M": preload("res://oggetti/cifrario cesare/lettere/M/M.tscn"), 
	"N": preload("res://oggetti/cifrario cesare/lettere/N/N.tscn"), 
	"O": preload("res://oggetti/cifrario cesare/lettere/O/O.tscn"), 
	"P": preload("res://oggetti/cifrario cesare/lettere/P/P.tscn"), 
	"Q": preload("res://oggetti/cifrario cesare/lettere/Q/Q.tscn"), 
	"R": preload("res://oggetti/cifrario cesare/lettere/R/R.tscn"), 
	"S": preload("res://oggetti/cifrario cesare/lettere/S/S.tscn"), 
	"T": preload("res://oggetti/cifrario cesare/lettere/T/T.tscn"), 
	"U": preload("res://oggetti/cifrario cesare/lettere/U/U.tscn"), 
	"V": preload("res://oggetti/cifrario cesare/lettere/V/V.tscn"), 
	"W": preload("res://oggetti/cifrario cesare/lettere/W/W.tscn"), 
	"X": preload("res://oggetti/cifrario cesare/lettere/X/X.tscn"), 
	"Y": preload("res://oggetti/cifrario cesare/lettere/Y/Y.tscn"), 
	"Z": preload("res://oggetti/cifrario cesare/lettere/Z/Z.tscn") 
}

var parola_attuale = "" 
var lettere_in_scena = []   

func _ready():
	if bottone:
		bottone.bottone_premuto.connect(_avvia_animazione_cifrario)
		
	# Ascoltiamo il Terminale 3D invece del vecchio LineEdit
	if terminale:
		terminale.parola_confermata.connect(_su_testo_inserito)

# Questa funzione viene chiamata quando il Terminale ci invia la parola finita
func _su_testo_inserito(nuovo_testo: String):
	# Trasforma tutto in maiuscolo (così "ciao" diventa "CIAO" e trova i modelli)
	parola_attuale = nuovo_testo.to_upper()
	
	# Genera i modelli 3D
	mostra_parola(parola_attuale)
	
	# Abbiamo rimosso casella_testo.clear() e l'impostazione del mouse
	# perché non servono più con il sistema 3D!

func mostra_parola(parola: String):
	for lettera in lettere_in_scena:
		lettera.queue_free()
	lettere_in_scena.clear()
	
	var distanza_tra_lettere = 1.0 
	var offset_x = 0.0
	
	for carattere in parola:
		if modelli_lettere.has(carattere):
			var istanza = modelli_lettere[carattere].instantiate()
			punto_spawn.add_child(istanza)
			istanza.position = Vector3(offset_x, 0, 0)
			lettere_in_scena.append(istanza)
			
		offset_x += distanza_tra_lettere

func _avvia_animazione_cifrario():
	print("Avvio animazione e cifratura...")
	var tempo_animazione = 1.5
	
	for lettera in lettere_in_scena:
		var tween = create_tween()
		tween.tween_property(lettera, "rotation_degrees:y", 1080.0, tempo_animazione).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		tween.parallel().tween_property(lettera, "position:y", 1.0, tempo_animazione/2.0).set_trans(Tween.TRANS_SINE)
		tween.parallel().tween_property(lettera, "position:y", 0.0, tempo_animazione/2.0).set_trans(Tween.TRANS_BOUNCE).set_delay(tempo_animazione/2.0)
	
	await get_tree().create_timer(tempo_animazione).timeout
	print("Animazione finita!")
