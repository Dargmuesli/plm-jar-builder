---
external help file: PLM-help.xml
Module Name: PLM-Jar-Builder
online version: https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJar.md
schema: 2.0.0
---

# Get-PlmJar

## SYNOPSIS
Downloads a PLM-Jar from the PLM webservice.

## SYNTAX

### Newest (Default)
```
Get-PlmJar -Session <WebRequestSession> -UserUsername <String> -UserPassword <SecureString>
 [-DownloadPath <String>] [<CommonParameters>]
```

### All
```
Get-PlmJar -Session <WebRequestSession> -UserUsername <String> -UserPassword <SecureString>
 [-DownloadPath <String>] [-All] [<CommonParameters>]
```

### ExerciseNumber
```
Get-PlmJar -Session <WebRequestSession> -UserUsername <String> -UserPassword <SecureString>
 [-DownloadPath <String>] [-ExerciseNumber <Int32[]>] [<CommonParameters>]
```

### ListAvailable
```
Get-PlmJar -Session <WebRequestSession> -UserUsername <String> -UserPassword <SecureString> [-ListAvailable]
 [<CommonParameters>]
```

## DESCRIPTION
The "Get-PlmJar" cmdlet searched for download links on the PLM's submissions page and filters them according to the given parameters.
It either returns all available download options or downloads the specified archives.

## EXAMPLES

### EXAMPLE 1
```
$UserUsername = "123456789"
```

$Session = Initialize-PlmSession -PlmUsername "PLM" -UserUsername $UserUsername

Get-PlmJar -Session $Session -Username $UserUsername -DownloadPath "D:\Downloads"
Get-PlmJar -Session $Session -Username $UserUsername -DownloadPath "D:\Downloads" -ExerciseNumber @(1, 2)
Get-PlmJar -Session $Session -Username $UserUsername -ListAvailable

## PARAMETERS

### -Session
A web session to the PLM website.

```yaml
Type: WebRequestSession
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserUsername
The user's username authenticate for download permissions.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserPassword
The user's password authenticate for download permissions.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DownloadPath
The path to which the jar files are to be downloaded to.

```yaml
Type: String
Parameter Sets: Newest, All, ExerciseNumber
Aliases:

Required: False
Position: Named
Default value: (Get-DownloadFolder)
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExerciseNumber
The exercise numbers for which jar files are to be downloaded.

```yaml
Type: Int32[]
Parameter Sets: ExerciseNumber
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Whether to download all available jar files.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListAvailable
Whether to list all available download options.

```yaml
Type: SwitchParameter
Parameter Sets: ListAvailable
Aliases:

Required: True
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

[https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJar.md](https://github.com/Dargmuesli/plm-jar-builder/blob/master/PLM-Jar-Builder/Docs/Get-PlmJar.md)

