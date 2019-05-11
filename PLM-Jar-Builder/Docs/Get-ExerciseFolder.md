---
external help file: JAR-help.xml
Module Name: PLM-Jar-Builder
online version: https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-ExerciseFolder.md
schema: 2.0.0
---

# Get-ExerciseFolder

## SYNOPSIS
Gets exercise folders.

## SYNTAX

### All (Default)
```
Get-ExerciseFolder [-ExerciseRootPath] <String> [<CommonParameters>]
```

### Newest
```
Get-ExerciseFolder [[-ExerciseRootPath] <String>] [-Newest] [<CommonParameters>]
```

### ExerciseNumber
```
Get-ExerciseFolder [[-ExerciseRootPath] <String>] [-ExerciseNumber] <Int32[]> [<CommonParameters>]
```

## DESCRIPTION
The "Get-ExerciseFolder" cmdlet searches an exercise root path for folders matching the exercise folder regular expression and returns its findings.

## EXAMPLES

### EXAMPLE 1
```
Get-ExerciseFolder -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen"
```

Get-ExerciseFolder -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen" -ExerciseNumbers @(1, 2)
Get-ExerciseFolder -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen" -Newest
Get-ExerciseFolder -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen" -ListAvailable

## PARAMETERS

### -ExerciseRootPath
The path to the directory that contains the exercise folders.

```yaml
Type: String
Parameter Sets: All
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: String
Parameter Sets: Newest, ExerciseNumber
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExerciseNumber
The exercise numbers for which folders are to be found.

```yaml
Type: Int32[]
Parameter Sets: ExerciseNumber
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Newest
Whether to return only the exercise folder with the highest exercise number.

```yaml
Type: SwitchParameter
Parameter Sets: Newest
Aliases:

Required: True
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-ExerciseFolder.md](https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-ExerciseFolder.md)

