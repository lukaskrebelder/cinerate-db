-- CineRate Schema-Erweiterung: Für Registrierung und Anmeldung.
-- Dazu kommen Vor- und Nachname und optional der Benutzername und eine Tabelle für Sitzungen.
-- Mehrfach ausfuehrbar (idempotent), da migrate.js alle Dateien jedes Mal ausfuehrt.

-- Vor- und Nachname für die Registrierung (Pflicht wird im Backend geprüft)
ALTER TABLE Nutzer ADD COLUMN IF NOT EXISTS vorname TEXT;
ALTER TABLE Nutzer ADD COLUMN IF NOT EXISTS nachname TEXT;

-- Benutzername ist nicht mehr Pflicht
ALTER TABLE Nutzer ALTER COLUMN benutzername DROP NOT NULL;

-- Sitzungen: ein Eintrag pro Anmeldung (Token wird nur als Hash gespeichert)
CREATE TABLE IF NOT EXISTS Sitzung (
    id SERIAL PRIMARY KEY,
    nutzer_id INTEGER NOT NULL REFERENCES Nutzer(id) ON DELETE CASCADE,
    token_hash TEXT NOT NULL UNIQUE,
    erstellt_am TIMESTAMP NOT NULL DEFAULT NOW(),
    laeuft_ab_am TIMESTAMP NOT NULL DEFAULT (NOW() + INTERVAL '24 hours')
);
