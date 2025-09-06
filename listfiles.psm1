# Import-Module .\dotenv.psm1

function Get-Videos {

    param (
        [String] 
        $directory = "./"
    )

    Write-Debug $directory

    $includePatterns = (
        Get-ItemProperty registry::HKEY_CLASSES_ROOT\.* -ErrorAction Ignore | Where-Object PerceivedType -eq video
    ).PSChildName -replace '^', '*'

    $files = Get-Item $directory\* -Include $includePatterns
    $files.Name
}

function Get-VideoID {

    param (
        [Parameter(Mandatory, Position=0)]
        [String]
        $file
    )

    Set-Variable -Name IDLength -Value 11 -Option Constant

    $groupForID = "\[([a-zA-Z0-9_-]{$IDLength})\]"
    
    if ($_ -match $groupForID) {
        $id = $Matches[1]
        $id

        return
    }

    return $false
}

function Test-ID {

    param(
        [Parameter(Mandatory)]
        [String]
        $video
    )

    $baseUrl = "https://www.youtube.com/watch?v="
    $endpoint = "https://www.youtube.com/oembed?format=json&url="

    $id = Get-VideoID $video

    if (!$id) {
        return $false
    }

    $url = $endpoint + $baseUrl + $id

    try {
        $statusCode = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing | Select-Object StatusCode

        return $true
    }
    catch {

        # Unauthorized (Video embed is turned off)
        if ($statusCode -eq 401) {
            return $true
        }

        return $false
    }
}