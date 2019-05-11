---
external help file: Config-help.xml
Module Name: PLM-Jar-Builder
online version: https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJarBuilderConfigProperty.md
schema: 2.0.0
---

# Get-PlmJarBuilderConfigProperty

## SYNOPSIS
Gets a PLM-Jar-Builder configuration property.

## SYNTAX

### PropertyName
```
Get-PlmJarBuilderConfigProperty [-PropertyName] <String> [<CommonParameters>]
```

### PropertyPath
```
Get-PlmJarBuilderConfigProperty [-PropertyPath] <String> [<CommonParameters>]
```

## DESCRIPTION
The "Get-PlmJarBuilderConfigProperty" cmdlet reads the PLM-Jar-Builder configuration and creates one if none exists.
Then, it gets the correct PLM-Jar-Builder configuration property path and returns its value.

## EXAMPLES

### EXAMPLE 1
```
(Get-PlmJarBuilderConfigProperty -PropertyName "ExerciseRootPath").ExerciseRootPath
```

Get-PlmJarBuilderConfigProperty -PropertyPath "Custom.ExerciseRootPath"

## PARAMETERS

### -PropertyName
The property name of the property whose value is to be returned.

```yaml
Type: String
Parameter Sets: PropertyName
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertyPath
The property path of the property whose value is to be returned.

```yaml
Type: String
Parameter Sets: PropertyPath
Aliases:

Required: True
Position: 1
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

[https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJarBuilderConfigProperty.md](https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJarBuilderConfigProperty.md)

