---
external help file: PLM-help.xml
Module Name: PLM-Jar-Builder
online version: https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Publish-PlmJar.md
schema: 2.0.0
---

# Publish-PlmJar

## SYNOPSIS
Publishs a PLM-Jar.

## SYNTAX

```
Publish-PlmJar [-Session] <WebRequestSession> [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
The "Publish-PlmJar" cmdlet extracts the exercise number from the jar file's name and requests the PLM's upload site.
If the upload site currently does allow uploads a HTTPS post request for the given jar file is constructed and sent.

## EXAMPLES

### EXAMPLE 1
```
$Session = Initialize-PlmSession -PlmUsername "PLM" -UserUsername $UserUsername
```

Publish-PlmJar -Session $Session -Path "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen"
Publish-PlmJar -Session $Session -Path "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen\Aufgabenblatt 1\Lösung\123456789_01.jar"

## PARAMETERS

### -Session
A web session to the PLM website.

```yaml
Type: WebRequestSession
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path directly to an exercise root folder or to the jar file that is to be uploaded.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Publish-PlmJar.md](https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Publish-PlmJar.md)

