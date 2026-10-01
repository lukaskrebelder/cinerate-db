-- CineRate Schema-Erweiterung: Watchlist, Kommentare, FSK, Sternebewertung 1-5
-- Mehrfach ausfuehrbar (idempotent), da migrate.js alle Dateien jedes Mal ausfuehrt.

-- FSK-Freigabe am Film (PB-13), z. B. '0', '6', '12', '16', '18'
ALTER TABLE Film ADD COLUMN IF NOT EXISTS fsk TEXT;

-- Bewertung als Sterne von 1 bis 5 (PB-10) statt 1 bis 10
ALTER TABLE Bewertung DROP CONSTRAINT IF EXISTS bewertung_punktzahl_check;
ALTER TABLE Bewertung ADD CONSTRAINT bewertung_punktzahl_check CHECK (punktzahl BETWEEN 1 AND 5);

-- Watchlist (PB-08, PB-09): ein Film pro Nutzer hoechstens einmal
CREATE TABLE IF NOT EXISTS Watchlist (
  nutzer_id INTEGER NOT NULL REFERENCES Nutzer(id) ON DELETE CASCADE,
  film_id INTEGER NOT NULL REFERENCES Film(id) ON DELETE CASCADE,
  hinzugefuegt_am TIMESTAMP NOT NULL DEFAULT NOW(),
  PRIMARY KEY (nutzer_id, film_id)
);

-- Kommentare (PB-14): mehrere pro Nutzer und Film moeglich
CREATE TABLE IF NOT EXISTS Kommentar (
  id SERIAL PRIMARY KEY,
  nutzer_id INTEGER NOT NULL REFERENCES Nutzer(id) ON DELETE CASCADE,
  film_id INTEGER NOT NULL REFERENCES Film(id) ON DELETE CASCADE,
  text TEXT NOT NULL,
  erstellt_am TIMESTAMP NOT NULL DEFAULT NOW()
);
