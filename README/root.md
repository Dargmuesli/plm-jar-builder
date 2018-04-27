[![Build status](https://ci.appveyor.com/api/projects/status/ba8i29gqp62lw4rp/branch/master?svg=true)](https://ci.appveyor.com/project/Dargmuesli/plm-jar-builder/branch/master)

# PLM-Jar-Builder
Erstellt .jar-Dateien für EECS/PLM Java-Projekte an der Universität Kassel.

## Inhaltsverzeichnis
1. **[Disclaimer](#Disclaimer)**
2. **[Hintergrund](#Background)**
3. **[Installation](#Installation)**
4. **[Benutzung](#Usage)**
5. **[Funktion](#Functionality)**
6. **[Konfiguration](#Configuration)**
7. **[Hinweise](#Hints)**
8. **[Module](#Modules)**

<a name="Disclaimer"></a>

## Disclaimer
Dieses PowersShell-Tool ist weder die Lösung einer Aufgabe selbst, noch soll es dem/der Studierenden das Erlernen des Umgangs mit der Konsole verhindern. Der Einsatz ist eigenverantwortlich.

<a name="Background"></a>

## Hintergrund
Im Rahmen der Lehrveranstaltung "Einführung in die Programmierung" im Fachbereich 16 (Elektrotechnik/Informatik) der Universität Kassel müssen Übungen bearbeitet und abgegeben werden.
Die Bearbeitung umfasst das Anfertigen von Dokumenten und Java-Programmen, die nur als jar-Archiv zusammengefasst hochgeladen/abgegeben werden können.
Daraus entstand die Idee für einen Assistenten, der einem beim Erstellen, Hoch- und Herunterladen von .jar-Dateien hilft.

<a name="Installation"></a>

## Installation
Zu Installation müssen in einem PowerShell-Fenster die zwei folgenden Befehle ausgeführt werden:

```PowerShell
Install-Module "PSDepend" -Scope "CurrentUser" -Force
Invoke-PSDepend -InputObject @{"dargmuesli/PLM-Jar-Builder" = "latest"} -Install -Force
```

<a name="Usage"></a>

## Benutzung
In erster Linie sollte der Assistent verwendet werden, der durch die möglichen Funktionen des Moduls führt.
Dazu in einem PowerShell-Fenster einfach folgenden Befehl eingeben:

```PowerShell
Invoke-PlmJarBuilder
```

### Screenshot
![Screenshot](Resources/Screenshot.png "Screenshot")

Alternativ können auch [einzelne Module](#Module) direkt angesprochen werden.

<a name="Functionality"></a>

## Funktion
Es wird eine Ordnerstruktur ähnlich zur folgenden vorausgesetzt:

```
Übungen\
├── Aufgabenblatt 1\
│   ├── Lösung\
│   │   ├── Teilaufgabe\
│   │   │   ├── Teilaufgabe.class
│   │   │   ├── Teilaufgabe.java
|   |   |   ⇣
│   │   ├── 123456789_01.jar
│   │   ├── Lösung 1.odt
│   │   ├── Lösung 1.pdf
│   │   ├── Teilaufgabe.odg
│   │   ├── Teilaufgabe.pdf
|   |   ⇣
│   ├── Aufgabenblatt 1.pdf
|   ⇣
├── Aufgabenblatt 2\
⇣
```

Die `.jar`-Datei wird standardmäßig beim Generieren überschrieben.
Dabei werden gewisse Dateitypen (`.odt`, `.class`), sowie IDE-abhängige Ordner (`.idea\`) ignoriert.

<a name="Configuration"></a>

## Konfiguration
Die Standardwerte, die bei der Ausführung vom PLM-Jar-Builder genutzt werden, können in einer Konfigurationsdatei angepasst werden.
Die Konfigurationsdatei befindet sich im Modul-Ordner, meist hier: `%USERPROFILE%\Documents\WindowsPowerShell\Modules\plm-jar-builder\PLM-Jar-Builder\Config\PLM-Jar-Builder.json`

Folgende Einstellungsmöglichkeiten gibt es:


### Custom
Einstellungen, die dem Benutzer die Eingabe von Funktionsparametern ersparen, aber die Programmfunktion nicht grundlegend ändern.

- **ExerciseRootPath**
Der Pfad zum Ordner, in dem sich die Aufgabenordner (`Aufgabenblatt 1`, ...) befinden.
Standardwert: `%MyDocuments%\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen`

- **DownloadPath**
Der Pfad zum Ordner, in den .jar-Dateien heruntergeladen werden.
Standardwert: `%Downloads%` (Registry-Schlüssel)

- **Exclude**
Dateiendungen als Regex, die nicht in die .jar-Datei gepackt werden sollen.
Standardwert: `".*\.class", ".*\.eml", ".*\.iml", ".*\.jar", ".*\.odt", ".*\.odg", ".*\.old", "[^\\]+\\\.idea\\.*", ".*\\In\.java", "[^\\]+\\out\\.*", ".*\\Out\.java"`

- **NoNote**
Festlegen, ob eine Markdown-Notiz bezüglich dieses Moduls mit in die .jar-Datei gepackt werden soll.
Standardwert: `false`


#### PLM
Daten, die im Browser-Authentifizierungsfenster angegeben werden müssen, bevor man die PLM-Seite überhaupt sieht.

- **Username**
Der PLM-Benutzername.
Standardwert: `""`

- **EncryptedPassword**
Eine [verschlüsselte Version](#verschlüsselte-passwörter) des PLM-Passworts.
Standardwert: `""`


#### User
Daten, die zur Anmeldung direkt auf der PLM-Seite genutzt werden.

- **MatriculationNumber**
Die Matrikelnummer, die als Benutzername für die PLM-Seite im Dateinamen der .jar-Datei vorkommen soll.
Standardwert: `""`

- **EncryptedPassword**
Eine [verschlüsselte Version](#verschlüsselte-passwörter) des Benutzerpassworts.
Standardwert: `""`


### Default
Einstellungen, die die Funktion des Moduls grundlegend ändern, weil sie Änderungen an der vorgegebenen Ordnerhierarchie darstellen.

- **SolutionPath**
Der Pfad zum Order innerhalb des Aufgabenordners, der die Lösung enthält.
Darin sollten alle Dateien sein, die in die .jar-Datei gepackt werden sollen.
Standardwert: `"Lösung"`

- **ExerciseSheetRegex**
Der reguläre Ausdruck, nach dem Aufgabenordner und Übungsnummern gefunden werden.
Standardwert: `"^Aufgabenblatt (\\d{1,2})$"`

- **JarFileRegex**
Der reguläre Ausdruck, nach dem .jar-Dateien, Matrikelnummern und Übungsnummern gefunden werden.
Standardwert: `"^(\\d+|.*)_(\\d{2}).jar$"`

<a name="Hints"></a>

## Hinweise

### Verschlüsselte Passwörter
Der Wert für das verschlüsselte Passwort kann über folgendes Kommando erstellt werden:

```PowerShell
'passwort' | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
```

Dass Apostrophe das Passwort einschließen ist notwendig, um gewisse Sonderzeichen im Passwort zu ermöglichen.
Das Passwort kann nur vom selben Windows-Account wieder entschlüsselt werden, mit dem es verschlüsselt wurde.


### Installation von Abhängigkeiten
Die Installation von Abhängigkeiten wird über das PowerShell-Modul [PSDepend](https://github.com/RamblingCookieMonster/PSDepend) realisiert. Die dortige, aktuelle Implementierung der Abhängigkeitsauflösung von GitHub-Projekten nicht wirklich ausgefeilt ist, dauert es oft lange bis alle Abhängigkeiten installiert sind. Besonders bei der Ausführung des Assistenten (`Invoke-PlmJarBuilder`) stört dies, sodass die Option `-SkipDependencyCheck` eingerichtet wurde, die die Abhängigkeitsauflösung verhindert. Gleichzeitig wird aber auch die Suche nach Updates übersprungen.

Der PLM-Jar-Builder nutzt u.a. das Projekt [Dargmuesli/PowerShell-Lib](https://github.com/Dargmuesli/PowerShell-Lib) von GitHub, das mit der derzeitigen Implementierung bei jeder Ausführung des Assistenten neu heruntergeladen wird. Es gibt bereits [einen neue Version](https://github.com/RamblingCookieMonster/PSDepend/pull/46) der GitHub-Installationsmethode über PSDepend, aber diese wurde dem Projekt noch nicht offiziell hinzugefügt.

<a name="Modules"></a>
