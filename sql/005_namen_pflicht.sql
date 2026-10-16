-- CineRate Schema-Anpassung: Vor- und Nachname sind Pflicht.
-- Das Backend verlangt beide bei der Registrierung schon; ab jetzt erzwingt es auch die Datenbank.
-- Mehrfach ausfuehrbar (idempotent): SET NOT NULL ändert nichts, wenn die Spalte schon NOT NULL ist.

ALTER TABLE Nutzer ALTER COLUMN vorname SET NOT NULL;
ALTER TABLE Nutzer ALTER COLUMN nachname SET NOT NULL;