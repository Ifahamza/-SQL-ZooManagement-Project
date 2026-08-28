

# SQL ZooManagement Datenbank

Ein umfassendes, relationales Datenbanksystem zur Verwaltung eines modernen Zoos. Dieses Projekt wurde im Rahmen einer intensiven SQL-Weiterbildung als **Teamprojekt** entwickelt und simuliert reale Geschäftsprozesse, darunter Tierhaltung, Mitarbeiterverwaltung, Fütterungslogistik und tierärztliche Versorgung.

Das System legt besonderen Wert auf **Datenintegrität, Business-Logik und Compliance** (z. B. Tierschutzbestimmungen) durch den Einsatz von Stored Procedures, Triggern, Funktionen und Views.

##  Tech Stack
* **Datenbank:** Microsoft SQL Server (T-SQL)
* **Tools:** SQL Server Management Studio (SSMS)
* **Konzepte:** Normalisierung, Foreign Keys, Check Constraints, Stored Procedures, Triggers (AFTER INSERT/UPDATE), Skalar- & Tabellenwertfunktionen, Views (INNER/LEFT JOINs).

---

##  Meine persönlichen Beiträge (Hamza Ifa)

Als Teil des Entwicklungsteams war ich speziell für das **Mitarbeiter-Management, die Tierzuweisung und die Compliance-Sicherstellung** zuständig. Mein Fokus lag auf der Implementierung strenger Geschäftsregeln und Sicherheitsprüfungen.

### 1. Gespeicherte Prozedur: `sp_TierZuweisen`
Eine komplexe Prozedur zur sicheren Zuweisung von Tieren zu Mitarbeitern. Sie enthält **5 integrierte Sicherheitsprüfungen**, um Datenkonsistenz und Tierwohl zu gewährleisten:
1. **Existenz-Check:** Prüft, ob Mitarbeiter und Tier in der Datenbank existieren.
2. **Berechtigungs-Check:** Stellt sicher, dass nur autorisiertes Personal (Tierpfleger/Revierleiter) Tiere betreuen darf.
3. **Verfügbarkeits-Check:** Verhindert Doppelzuweisungen (ein Tier darf nur einen aktiven Betreuer haben).
4. **Überlastungsschutz (Business-Logik Highlight):** Nutzt eine Skalarwertfunktion, um die aktuelle Tieranzahl zu prüfen. Im Normalfall sind max. **12 Tiere** erlaubt, im Notfall (z. B. Krankheitsvertretung) bis zu **15 Tiere**.
5. **Rückgabe von Status:** Gibt Erfolg oder detaillierte Fehlermeldungen über `OUTPUT`-Parameter zurück.

### 2. Trigger: `trg_Tierbetreuung_Berechtigung`
Ein `AFTER INSERT` Trigger auf der Tabelle `Tierbetreuung`. Dient als letztes Sicherheitsnetz (Compliance/Tierschutz). Er verhindert automatisch auf Datenbankebene, dass unberechtigtes Personal (z. B. Verwaltung oder Techniker) als Tierbetreuer eingetragen wird, und bricht die Transaktion bei Verstößen ab (`ROLLBACK`).

### 3. Funktionen (Functions)
* **Skalarwertfunktion `sf_AnzahlBetreuterTiere`:** Zählt die Anzahl der *aktiven* Betreuungen (`BisDatum IS NULL`) eines bestimmten Mitarbeiters. Wird zentral für den Überlastungsschutz in der Prozedur genutzt.
* **Tabellenwertfunktion `tf_AktuelleBetreuung`:** Gibt eine vollständige Liste aller aktuell betreuten Tiere eines Pflegers zurück (inkl. Tierart und Zeitraum). Ideal für die Generierung täglicher Arbeitslisten.

### 4. Views (Sichten)
* **`v_AlleMitarbeiterMitBetreuung`:** Eine komplexe Übersicht aller aktiven Tierbetreuungen. Verknüpft **5 Tabellen** (`Mitarbeiter`, `Tierbetreuung`, `Tier`, `Tierart`, `Gehege`) mittels `INNER JOIN`.
* **`v_MitarbeiterStruktur`:** Zeigt alle Mitarbeiter mit ihren aktuellen Tieren. Nutzt `LEFT JOIN`, um auch Mitarbeiter anzuzeigen, die aktuell keine Tiere betreuen (z. B. Verwaltungspersonal).

---

##  Team-Beiträge & Weitere Module

Das Projekt wurde in enger Zusammenarbeit entwickelt. Weitere Kernmodule umfassen:

###  Fütterungs- & Lager-Management (Martina Kratt)
* Verwaltung von Futterplänen, Lagerbeständen und täglichen Fütterungen.
* **Highlight:** Trigger `tr_Fuetterung_Lagerbestand`, der den Lagerbestand nach jeder Fütterung automatisch reduziert, und Prozeduren zur Reichweitenberechnung.

###  Gehege- & Gewichts-Management (Bernhard Ehnle & Maximilian von der Bank)
* Verwaltung von Gehegen, Kapazitäten und Tierart-Zuordnungen.
* **Highlight:** Trigger `tr_TierGewichtPruefen`, der automatisch eine Warnung protokolliert, wenn das Gewicht eines Tieres stark vom Durchschnitt seiner Tierart abweicht (>50%).

### 🩺 Tierärztliche Untersuchungen (Javier Montanez)
* Dokumentation von Untersuchungen, Kosten und Folge-Terminen.
* **Highlight:** Automatische Berechnung des nächsten Untersuchungstermins basierend auf dem Tieralter (Senior-Tiere alle 3 Monate, normale Tiere jährlich).

---

## 🚀 Installation & Ausführung

Um die Datenbank lokal aufzusetzen, benötigen Sie Microsoft SQL Server und SQL Server Management Studio (SSMS).

1. Klonen oder laden Sie dieses Repository herunter.
2. Öffnen Sie SSMS und verbinden Sie sich mit Ihrer SQL Server Instanz.
3. Öffnen Sie die Datei **`20260827_Backup_DB_Script_ZooManagement.sql`**.
4. Führen Sie das Skript aus (F5). 
   * *Das Skript erstellt die Datenbank `ZooManagement`, alle Tabellen, Constraints, Indizes, Views, Funktionen, Prozeduren und Trigger und füllt sie mit realistischen Testdaten.*
5. Erweitern Sie im Objekt-Explorer den Knoten `ZooManagement` -> `Tabellen` / `Programmierbarkeit`, um die Objekte zu erkunden.

## 📂 Projektstruktur (Empfohlen)

Für eine saubere Entwicklung empfiehlt sich folgende Ordnerstruktur im Repository:

```text
SQL-ZooManagement-Project/
│
├── Database_Setup/          # Datenbank-Erstellung & Tabellen-Struktur
├── Constraints/             # Foreign Keys & Check Constraints
├── Programmability/
│   ├── Views/               # Alle Views (inkl. meiner Mitarbeiter-Views)
│   ├── Functions/           # Skalar- & Tabellenwertfunktionen
│   ├── Stored_Procedures/   # Geschäftslogik (inkl. sp_TierZuweisen)
│   └── Triggers/            # Automatisierung & Compliance (inkl. trg_Tierbetreuung)
├── Data/                    # INSERT-Statements für Testdaten
└── README.md                # Diese Datei




