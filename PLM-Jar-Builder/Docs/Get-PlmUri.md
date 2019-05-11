---
external help file: PLM-help.xml
Module Name: PLM-Jar-Builder
online version: https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmUri.md
schema: 2.0.0
---

# Get-PlmUri

## SYNOPSIS
Gets a PLM-URI.

## SYNTAX

```
Get-PlmUri [-Type] <String> [<CommonParameters>]
```

## DESCRIPTION
The "Get-PlmUri" cmdlet builds a PLM-URI from its base components and the given type that is translated to a pageID number.

## EXAMPLES

### EXAMPLE 1
```
Get-PlmUri -Type "Login"
```

Get-PlmUri -Type "Upload"
Get-PlmUri -Type "Download"

## PARAMETERS

### -Type
The URI's type that is to be returned.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

[https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmUri.md](https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmUri.md)

