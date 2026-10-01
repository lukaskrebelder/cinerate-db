# cinerate-db

Datenbankschema und Migrationen für CineRate (PostgreSQL). Teil der Fallstudie
Software Engineering, WS 2026/27.

Dieses Repository enthält **nur Strukturdefinitionen**, keine Laufzeitlogik.
Die eigentliche Anwendungslogik liegt in [cinerate-backend](../cinerate-backend).

## Tabellen

- `Nutzer` – registrierte Nutzer
- `Film` – über TMDB importierte und lokal gecachte Filme
- `Genre` – Filmgenres
- `Film_Genre` – n:m-Beziehung zwischen Film und Genre
- `Bewertung` – Bewertungen eines Nutzers zu einem Film (1 Bewertung pro Nutzer/Film)

## Schema anwenden

```
npm install
cp .env.example .env   # DATABASE_URL eintragen
npm run migrate
```

Führt alle `.sql`-Dateien aus `sql/` der Reihe nach gegen die in `DATABASE_URL`
angegebene PostgreSQL-Datenbank aus.
