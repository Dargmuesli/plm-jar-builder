---
external help file: PLM-help.xml
Module Name: PLM-Jar-Builder
online version: https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Test-PlmUploadAvailable.md
schema: 2.0.0
---

# Test-PlmUploadAvailable

## SYNOPSIS
Tests the availability of PLM-Jar uploads.

## SYNTAX

### Session (Default)
```
Test-PlmUploadAvailable [-Session] <WebRequestSession> [<CommonParameters>]
```

### Request
```
Test-PlmUploadAvailable [-Request] <BasicHtmlWebResponseObject> [<CommonParameters>]
```

## DESCRIPTION
The "Test-PlmUploadAvailable" cmdlet optionally requests PLM's upload site and searches for the information that uploads are currently disabled.
If they are $False is returned, otherwise $True.

## EXAMPLES

### EXAMPLE 1
```
$UploadUri = Get-PlmUri -Type "Upload"
```

$Session = Initialize-PlmSession -PlmUsername "PLM" -UserUsername $UserUsername
$Request = Invoke-WebRequest \`
    -Uri $UploadUri \`
    -WebSession $Session

Test-PlmUploadAvailable -Session $Session
Test-PlmUploadAvailable -Request $Request

## PARAMETERS

### -Session
A web session to the PLM website.

```yaml
Type: WebRequestSession
Parameter Sets: Session
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Request
A web request to PLM's upload site.

```yaml
Type: BasicHtmlWebResponseObject
Parameter Sets: Request
Aliases:

Required: True
Position: 1
Default value: None
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

[https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Test-PlmUploadAvailable.md](https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Test-PlmUploadAvailable.md)

