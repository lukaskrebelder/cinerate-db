-- CineRate Schema-Anpassungen aus der Sprintplanung vom 15.10.2026 (PB-16).
-- Mehrfach ausfuehrbar (idempotent), da migrate.js alle Dateien jedes Mal ausfuehrt.

-- Bewertung ist nur noch Sterne (1-5); ein Rezensionstext ist nicht vorgesehen.
ALTER TABLE Bewertung DROP COLUMN IF EXISTS rezensionstext;

-- Kommentare koennen vom Autor bearbeitet werden; NULL = nie bearbeitet.
ALTER TABLE Kommentar ADD COLUMN IF NOT EXISTS aktualisiert_am TIMESTAMP;

-- Es gibt nur noch die Rollen Nutzer und Moderator (Admin entfaellt).
UPDATE Nutzer SET rolle = 'Moderator' WHERE rolle = 'Admin';
ALTER TABLE Nutzer DROP CONSTRAINT IF EXISTS nutzer_rolle_check;
ALTER TABLE Nutzer ADD CONSTRAINT nutzer_rolle_check CHECK (rolle IN ('Nutzer', 'Moderator'));

-- Indizes fuer haeufige Abfragen
CREATE INDEX IF NOT EXISTS idx_sitzung_nutzer ON Sitzung (nutzer_id);
CREATE INDEX IF NOT EXISTS idx_sitzung_laeuft_ab ON Sitzung (laeuft_ab_am);
CREATE INDEX IF NOT EXISTS idx_bewertung_film ON Bewertung (film_id);
CREATE INDEX IF NOT EXISTS idx_kommentar_film ON Kommentar (film_id, erstellt_am);