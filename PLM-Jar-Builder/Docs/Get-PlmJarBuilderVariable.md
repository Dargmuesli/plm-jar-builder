---
external help file: Config-help.xml
Module Name: PLM-Jar-Builder
online version: https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJarBuilderVariable.md
schema: 2.0.0
---

# Get-PlmJarBuilderVariable

## SYNOPSIS
Gets a PLM-Jar-Builder variable.

## SYNTAX

### Name (Default)
```
Get-PlmJarBuilderVariable [-Name] <String> [<CommonParameters>]
```

### ListAvailable
```
Get-PlmJarBuilderVariable [-ListAvailable] [<CommonParameters>]
```

## DESCRIPTION
The "Get-PlmJarBuilderVariable" cmdlet returns a local script variable or lists all available.

## EXAMPLES

### EXAMPLE 1
```
Get-PlmJarBuilderVariable -Name "ModuleName"
```

Get-PlmJarBuilderVariable -ListAvailable

## PARAMETERS

### -Name
The variable's name whose value is to be returned.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListAvailable
Whether all available options are to be returned.

```yaml
Type: SwitchParameter
Parameter Sets: ListAvailable
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable.
For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJarBuilderVariable.md](https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJarBuilderVariable.md)

