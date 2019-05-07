---
external help file: Config-help.xml
Module Name: PLM-Jar-Builder
online version: https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/New-PlmJarConfig.md
schema: 2.0.0
---

# New-PlmJarConfig

## SYNOPSIS
Creates a new PLM-Jar-Builder config.

## SYNTAX

```
New-PlmJarConfig [[-ExerciseRootPath] <String>] [[-DownloadPath] <String>] [[-Exclude] <Object>] [-NoNote]
 [[-PlmUsername] <String>] [[-PlmPasswordEncrypted] <SecureString>] [[-MatriculationNumber] <String>]
 [[-UserPasswordEncrypted] <SecureString>] [[-SolutionPath] <String>] [[-ExerciseSheetRegex] <String>]
 [[-JarFileRegex] <String>]
```

## DESCRIPTION
The "New-PlmJarConfig" cmdlet creates a new PLM-Jar-Builder configuration file containing the specified values.

## EXAMPLES

### EXAMPLE 1
```
New-PlmJarConfig
```

## PARAMETERS

### -ExerciseRootPath
The path to the directory that contains the exercise folders.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: (Join-Path -Path $([Environment]::GetFolderPath("MyDocuments")) "Universität" "Informatik" "Semester 1" "Einführung in die Programmierung" "Übungen")
Accept pipeline input: False
Accept wildcard characters: False
```

### -DownloadPath
The path to download jar files to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: (Get-DownloadFolder)
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
A list of file extensions to exclude when packing the jar.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: @(".*\.class", ".*\.eml", ".*\.iml", ".*\.jar", ".*\.odt", ".*\.odg", ".*\.ods", ".*\.old", "[^\\]+\\\.idea\\.*", ".*\\In\.java", "[^\\]+\\out\\.*", ".*\\Out\.java")
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoNote
Whether to exclude a note regarding this tool in the jar.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlmUsername
The username for PLM's basic authentication.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PlmPasswordEncrypted
The password for PLM's basic authentication.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MatriculationNumber
The user's matriculation number / PLM username.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserPasswordEncrypted
The user's PLM password.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SolutionPath
The relative path from an exercise folder to its solution folder.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: Lösung
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExerciseSheetRegex
The regular expression that is used when looking for exercise folders.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: ^Aufgabenblatt (\d{1,2})$
Accept pipeline input: False
Accept wildcard characters: False
```

### -JarFileRegex
The regular expression that is used when looking for jar files.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: ^(\d+|.*)_(\d{2}).jar$
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/New-PlmJarConfig.md](https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/New-PlmJarConfig.md)

