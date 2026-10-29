# Karteikasten

Lernkarten für die Berufsschule als Web-App im Stil von iOS/iPadOS/macOS 27 (Liquid Glass).
Läuft auf iPhone, iPad und Mac – als App auf dem Home-Bildschirm, offline und ohne Installation aus einem Store.

## Funktionen

- **Fächer** mit Name und Farbe anlegen, umbenennen, löschen
- **Karten** selbst schreiben, bearbeiten, löschen (Wischen nach links, mit „Widerrufen“), in ein anderes Fach verschieben
- **Bilder auf Frage- und Antwortseite** (bis zu 6 je Seite): Fotos, Grafiken, technische Zeichnungen und PDFs in JPG, PNG, HEIC, GIF, WebP, AVIF, SVG, TIFF, BMP oder PDF (die ersten 4 Seiten); per Auswahl, Kamera, Drag & Drop oder Einfügen (⌘V)
- **Karten aus dem Claude-Chat einfügen** (kostenlos mit dem Claude-Abo): Anweisung kopieren, im Chat Foto/PDF/Text anhängen, Antwort einfügen – erkannt werden „F:/A:“, JSON, Tabellen, Quizlet- und Anki-Exporte sowie Begriffslisten
- **Bildansicht**: Antippen vergrößert; Zoomen mit zwei Fingern, Doppeltippen, Mausrad oder Trackpad, Wischen zum nächsten Bild, nach unten wischen zum Schließen; SVG bleibt beim Zoomen gestochen scharf
- **Skizzen zeichnen** mit Stift, Linie (rastet bei 0°/45°/90° ein), Rechteck, Kreis, Radierer und Raster – mit Apple Pencil inkl. Druckstärke und Handballenerkennung
- **Karten mit KI erstellen** aus einem Lerntext oder aus Fotos handschriftlicher Notizen – Skizzen werden auf Wunsch als Grafik nachgezeichnet, das Foto kann an die Karten angehängt werden
- **Lernen** mit Umdrehen per Tippen, Wischen (rechts = Weiß ich, links = Nochmal) oder Tastatur (Leertaste, ← →, ⌘Z)
- **Lernstufen (Leitner-System)**: Gewusste Karten kommen nach 1, 3, 7 und 16 Tagen wieder, nicht gewusste sofort noch einmal
- **Heute**: alle fälligen Karten aus allen Fächern, Tagesziel-Ring, Lernserie
- **Statistik**: letzte 7 Tage, Lernstufen, Fortschritt je Fach
- **Suche** über alle Fragen und Antworten
- **„Erklär mir das“**: Claude erklärt eine Antwort mit Beispiel oder Eselsbrücke
- **Rückgängig** für die letzte Antwort, **Umgekehrt abfragen**, **Mischen**
- **Sicherung** als JSON exportieren und importieren (z. B. vom Claude-Artefakt in die App)
- **Kein Seiten-Zoom**: Zoomen per Pinch oder Doppeltippen ist gesperrt (außer in der Bildansicht), Eingabefelder lösen keinen Auto-Zoom aus
- Filter „Alle / Fällig / Nicht gewusst“ im Fach, Treffer-Hervorhebung in der Suche, Nachfrage vor dem Verwerfen von Änderungen, Sheets per Wischen schließen, Tastatur verdeckt keine Eingabefelder
- Hell/Dunkel, Glas „Klar“ oder „Getönt“, Dynamic Type, VoiceOver, „Transparenz reduzieren“, „Bewegung reduzieren“, „Kontrast erhöhen“

## Abgleich zwischen Geräten (optional)

Die App speichert alles zuerst auf dem Gerät und funktioniert komplett offline. Mit einem kostenlosen Supabase-Projekt gleichen sich Fächer, Karten, Bilder und Lernstand zwischen Handy, iPad und PC ab, sobald Internet da ist.

1. Auf supabase.com ein Projekt anlegen (Region z. B. Frankfurt).
2. Im Projekt unter **SQL Editor** den Inhalt von [`supabase/setup.sql`](supabase/setup.sql) einfügen und **Run** drücken.
3. Unter **Authentication → Sign In / Providers → Email** „Confirm email“ ausschalten (sonst muss jede neue Anmeldung erst per Mail-Link bestätigt werden).
4. Unter **Project Settings → API** die *Project URL* und den *Publishable key* kopieren und in der App unter *Einstellungen → Geräte abgleichen* eintragen (oder in `index.html` bei `SYNC_DEFAULT` hinterlegen, dann entfällt das auf jedem Gerät).
5. Auf jedem Gerät mit derselben E-Mail und demselben Passwort anmelden.

Konflikte löst die App Karte für Karte: Die zuletzt geänderte Fassung gewinnt. Die Lernstatistik wird pro Gerät gespeichert und zusammengezählt.

## Auf dem iPhone installieren

1. Die App über HTTPS bereitstellen, z. B. mit GitHub Pages: *Settings → Pages → Branch `main`, Ordner `/ (root)`*.
2. Die Seite in Safari öffnen, **Teilen → Zum Home-Bildschirm**.

Die Karten und Bilder werden auf dem Gerät gespeichert (IndexedDB). PDF-, TIFF- und HEIC-Dateien (letztere nur außerhalb von Safari) brauchen beim ersten Öffnen eine Internetverbindung, danach sind die Bibliotheken zwischengespeichert. CAD-Formate wie DWG/DXF bitte vorher als PDF, SVG oder PNG exportieren. Für Karten aus Text oder Foto trägst du in den Einstellungen deinen eigenen API-Schlüssel von console.anthropic.com ein; er bleibt nur auf dem Gerät.

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
