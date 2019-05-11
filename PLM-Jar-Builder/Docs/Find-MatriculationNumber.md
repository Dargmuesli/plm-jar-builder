---
external help file: JAR-help.xml
Module Name: PLM-Jar-Builder
online version: https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Find-MatriculationNumber.md
schema: 2.0.0
---

# Find-MatriculationNumber

## SYNOPSIS
Finds a matriculation number.

## SYNTAX

```
Find-MatriculationNumber [-ExerciseRootPath] <String> [-All] [<CommonParameters>]
```

## DESCRIPTION
The "Find-MatriculationNumber" cmdlet searches an exercise root path for files matching the jar file regular expression, then extracts included matriculation numbers.

## EXAMPLES

### EXAMPLE 1
```
Find-MatriculationNumber -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen"
```

Find-MatriculationNumber -ExerciseRootPath "D:\Dokumente\Universität\Informatik\Semester 1\Einführung in die Programmierung\Übungen" -All

## PARAMETERS

### -ExerciseRootPath
The path to the directory that contains the exercise folders.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Whether to return all findings.
Without this switch only unique values are returned.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Find-MatriculationNumber.md](https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Find-MatriculationNumber.md)

