-- CineRate Datenbankschema (PostgreSQL)
-- Anwenden mit: psql $DATABASE_URL -f sql/001_init_schema.sql
-- oder über das Hilfsskript: node scripts/migrate.js

CREATE TABLE IF NOT EXISTS Nutzer (
  id SERIAL PRIMARY KEY,
  benutzername TEXT NOT NULL UNIQUE,
  email TEXT NOT NULL UNIQUE,
  passwort_hash TEXT NOT NULL,
  rolle TEXT NOT NULL DEFAULT 'Nutzer' CHECK (rolle IN ('Nutzer', 'Moderator', 'Admin')),
  erstellt_am TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS Film (
  id SERIAL PRIMARY KEY,
  tmdb_id INTEGER NOT NULL UNIQUE,
  titel TEXT NOT NULL,
  beschreibung TEXT,
  erscheinungsjahr INTEGER,
  poster_pfad TEXT,
  laufzeit INTEGER,
  erstellt_am TIMESTAMP NOT NULL DEFAULT NOW(),
  aktualisiert_am TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS Genre (
  id SERIAL PRIMARY KEY,
  tmdb_genre_id INTEGER NOT NULL UNIQUE,
  name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS Film_Genre (
  film_id INTEGER NOT NULL REFERENCES Film(id) ON DELETE CASCADE,
  genre_id INTEGER NOT NULL REFERENCES Genre(id) ON DELETE CASCADE,
  PRIMARY KEY (film_id, genre_id)
);

CREATE TABLE IF NOT EXISTS Bewertung (
  id SERIAL PRIMARY KEY,
  nutzer_id INTEGER NOT NULL REFERENCES Nutzer(id) ON DELETE CASCADE,
  film_id INTEGER NOT NULL REFERENCES Film(id) ON DELETE CASCADE,
  punktzahl INTEGER NOT NULL CHECK (punktzahl BETWEEN 1 AND 10),
  rezensionstext TEXT,
  erstellt_am TIMESTAMP NOT NULL DEFAULT NOW(),
  aktualisiert_am TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE (nutzer_id, film_id)
);
