# cinerate-db

Datenbankschema und Migrationen für CineRate (PostgreSQL). Teil der Fallstudie
Software Engineering, WS 2026/27.

Dieses Repository enthält **nur Strukturdefinitionen**, keine Laufzeitlogik.
Die eigentliche Anwendungslogik liegt in [cinerate-backend](../cinerate-backend).

## Tabellen

- `Nutzer` – registrierte Nutzer (Rolle: Nutzer, Moderator oder Admin)
- `Film` – über TMDB importierte und lokal gecachte Filme, inkl. FSK-Freigabe (`fsk`)
- `Genre` – Filmgenres
- `Film_Genre` – n:m-Beziehung zwischen Film und Genre
- `Bewertung` – Sternebewertung eines Nutzers zu einem Film (1 bis 5 Sterne, 1 Bewertung pro Nutzer/Film)
- `Watchlist` – Filme, die ein Nutzer merkt (jeder Film pro Nutzer höchstens einmal)
- `Kommentar` – Kommentare von Nutzern zu Filmen (mehrere pro Nutzer und Film möglich)

## Migrationen

Die Dateien in `sql/` werden der Reihe nach ausgeführt:

| Datei | Inhalt |
| --- | --- |
| `001_init_schema.sql` | Grundschema: Nutzer, Film, Genre, Film_Genre, Bewertung |
| `002_watchlist_kommentar_fsk.sql` | Watchlist, Kommentar, Spalte `fsk`, Bewertung auf 1–5 Sterne |

Regeln:

- Bereits eingecheckte Migrationsdateien werden **nicht mehr geändert**.
  Schemaänderungen kommen immer in eine neue Datei mit der nächsten Nummer,
  z. B. `003_beschreibung.sql`.
- `migrate.js` führt bei jedem Lauf **alle** Dateien erneut aus und merkt sich
  nicht, was schon angewendet wurde. Neue Migrationen müssen daher mehrfach
  ausführbar sein (`IF NOT EXISTS`, `DROP ... IF EXISTS` usw.).

## Schema anwenden

```
npm install
cp .env.example .env   # DATABASE_URL eintragen (Windows PowerShell: copy .env.example .env)
npm run migrate
```

Führt alle `.sql`-Dateien aus `sql/` der Reihe nach gegen die in `DATABASE_URL`
angegebene PostgreSQL-Datenbank aus.

### Heroku Postgres

Die `DATABASE_URL` der Heroku-Datenbank steht im Heroku-Dashboard unter
`cinerate-backend` → Settings → Config Vars. Für alle Datenbanken außer
`localhost` schaltet `migrate.js` automatisch SSL ein.

Die `.env` ist in der `.gitignore` und darf nie committed werden, da sie das
Datenbank-Passwort enthält.
