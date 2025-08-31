Set-Variable -Name NumSubstrings -Value 2 -Option Constant 

function Get-Dotenv {
    Get-Content .\.env | ForEach-Object {

        if ( [string]::IsNullOrWhiteSpace($_) ) {
            return
        }

        if ( $_.StartsWith('#') ) {
            return
        }

        if ( $_ -notmatch '=' ) {
            throw [System.IO.InvalidDataException] "ERROR: Invalid variable declaration caused by line [$_]."
        }

        $name, $value = $_.split('=', $NumSubstrings)

        Write-Host $name "=" $value
    }
}

function Set-Dotenv {
    Get-Content .\.env | ForEach-Object {

        if ( [string]::IsNullOrWhiteSpace($_) ) {
            return
        }

        if ( $_.StartsWith('#') ) {
            return
        }

        if ( $_ -notmatch '=' ) {
            throw [System.IO.InvalidDataException] "$_\: Invalid variable declaration."
        }

        $name, $value = $_.split('=', $NumSubstrings)

        Set-Content env:\$name $value 
    }
}

function Remove-Dotenv {
    Get-Content .\.env | ForEach-Object {

        if ( [string]::IsNullOrWhiteSpace($_) ) {
            return
        }

        if ( $_.StartsWith('#') ) {
            return
        }

        if ( $_ -notmatch '=' ) {
            throw [System.IO.InvalidDataException] "$_\: Invalid variable declaration."
        }

        $name, $value = $_.split('=', $NumSubstrings)

        Remove-Item env:\$name
    }
}