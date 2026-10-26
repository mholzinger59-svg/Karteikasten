# Karteikasten

Lernkarten für die Berufsschule als Web-App im Stil von iOS/iPadOS/macOS 27 (Liquid Glass).
Läuft auf iPhone, iPad und Mac – als App auf dem Home-Bildschirm, offline und ohne Installation aus einem Store.

## Funktionen

- **Fächer** mit Name und Farbe anlegen, umbenennen, löschen
- **Karten** selbst schreiben, bearbeiten, löschen (Wischen nach links, mit „Widerrufen“)
- **Karten mit KI erstellen** aus einem Lerntext oder aus Fotos handschriftlicher Notizen – Skizzen werden auf Wunsch als Grafik nachgezeichnet, das Foto kann an die Karten angehängt werden
- **Lernen** mit Umdrehen per Tippen, Wischen (rechts = Weiß ich, links = Nochmal) oder Tastatur (Leertaste, ← →, ⌘Z)
- **Lernstufen (Leitner-System)**: Gewusste Karten kommen nach 1, 3, 7 und 16 Tagen wieder, nicht gewusste sofort noch einmal
- **Heute**: alle fälligen Karten aus allen Fächern, Tagesziel-Ring, Lernserie
- **Statistik**: letzte 7 Tage, Lernstufen, Fortschritt je Fach
- **Suche** über alle Fragen und Antworten
- **„Erklär mir das“**: Claude erklärt eine Antwort mit Beispiel oder Eselsbrücke
- **Rückgängig** für die letzte Antwort, **Umgekehrt abfragen**, **Mischen**
- **Sicherung** als JSON exportieren und importieren (z. B. vom Claude-Artefakt in die App)
- Hell/Dunkel, Glas „Klar“ oder „Getönt“, Dynamic Type, VoiceOver, „Transparenz reduzieren“, „Bewegung reduzieren“, „Kontrast erhöhen“

## Auf dem iPhone installieren

1. Die App über HTTPS bereitstellen, z. B. mit GitHub Pages: *Settings → Pages → Branch `main`, Ordner `/ (root)`*.
2. Die Seite in Safari öffnen, **Teilen → Zum Home-Bildschirm**.

Die Karten werden auf dem Gerät gespeichert (IndexedDB). Für Karten aus Text oder Foto trägst du in den Einstellungen deinen eigenen API-Schlüssel von console.anthropic.com ein; er bleibt nur auf dem Gerät.

## Als Claude-Artefakt

Dieselbe Datei läuft auch als Claude-Artefakt. Dort werden die Fächer in Claude gesichert, und die KI-Funktionen laufen ohne eigenen Schlüssel.

```sh
python3 tools/build-artifact.py   # schreibt dist/karteikasten-artifact.html
```

## Lokal starten

```sh
python3 -m http.server 8000
# http://localhost:8000
```
