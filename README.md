
#  ZooManagement Datenbank (SQL Server)

Dies ist ein relationales Datenbanksystem zur Verwaltung eines Zoos. Es verwaltet Tiere, Gehege, Mitarbeiter, Fütterungspläne und tierärztliche Untersuchungen unter strenger Einhaltung von Business-Logik und Tierschutz-Compliance.

> **Hinweis:** Dieses Projekt wurde im Rahmen einer Weiterbildung als **Teamprojekt** entwickelt. 

##  Tech Stack
* **Datenbank:** Microsoft SQL Server (T-SQL)
* **Tools:** SQL Server Management Studio (SSMS)

##  Meine persönlichen Beiträge (Hamza Ifa)
Als Teil des Entwicklungsteams war ich speziell für die **Business-Logik, Compliance und Mitarbeiterverwaltung** zuständig. Folgende Objekte wurden von mir entwickelt:

### 1. Stored Procedure: `sp_TierZuweisen`
Automatisierte und sichere Zuweisung von Tieren zu Mitarbeitern. Die Prozedur enthält **5 integrierte Sicherheitsprüfungen**:
1. Existenz-Check (Mitarbeiter & Tier)
2. Berechtigungs-Check (Nur Tierpfleger/Revierleiter dürfen Tiere betreuen)
3. Verfügbarkeits-Check (Verhindert Doppelzuweisungen)
4. **Überlastungsschutz** (Max. 12 Tiere im Normalfall, 15 im Notfall)
5. Rückgabe von Erfolg/Fehler über OUTPUT-Parameter.

### 2. AFTER INSERT Trigger: `trg_Tierbetreuung_Berechtigung`
Ein Sicherheitsnetz auf Datenbankebene (Compliance/Tierschutz). Der Trigger verhindert automatisch auf Datenbankebene, dass unberechtigtes Personal (z.B. Verwaltung oder Techniker) als Tierbetreuer eingetragen wird, und bricht die Transaktion bei Verstößen ab.

## 📂 Projektstruktur
Das Repository enthält ein vollständiges Backup-Skript der Datenbank, das folgende Elemente umfasst:
* Tabellen, Primär- und Fremdschlüssel
* Views für Reporting und Übersicht
* Stored Procedures für Geschäftsprozesse
* Trigger für Datenintegrität
* Testdaten

##  Installation & Ausführung
1. Öffnen Sie SQL Server Management Studio (SSMS).
2. Führen Sie das Skript `20260827_Backup_DB_Script_ZooManagement.sql` aus, um die Datenbank `ZooManagement` zu erstellen und alle Objekte sowie Testdaten zu importieren.
