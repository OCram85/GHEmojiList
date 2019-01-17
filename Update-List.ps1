<#
    .SYNOPSIS
        Udates the README.md page with all available emojis

    .DESCRIPTION
        Use this script to get all availaible emojis from the github api.

    .PARAMETER Path
        You can provide a custom output path.

    .INPUTS
        [None]

    .OUTPUTS
        [None]

    .EXAMPLE
        .\Update-List.ps1

    .NOTES
        File Name   : Update-List.ps1
        Author      : Marco Blessing - marco.blessing@googlemail.com
        Requires    :

    .LINK
        https://github.com/OCram85/GHEmojiList
    #>
#Requires -Version 5.1
[CmdletBinding()]
[OutputType()]
param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$Path = "./README.MD"
)
begin {
    $rawList = Invoke-RestMethod -Method Get -Uri 'https://api.github.com/emojis'
    $Content = @()
}
process {
    $Header = @"
# Github Emoji List

## About
This list contains all available Emojis in [GitHub flavored Markdown](https://api.github.com/emojis).

## Emojis

| Emoji | Markdown | Image |
| ---- | -------- | ----- |
"@
    $Content += $HEADER
    $Emojis = $rawList | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty 'Name'
    foreach ($Emoji in $Emojis) {
        $Content += '| `:{0}:` | :{0}: | [{0}]({1}) |' -f $Emoji, $rawList.$Emoji
    }
    $Content | Set-Content -Path $Path -Force -Encoding UTF8
}
end {
}
