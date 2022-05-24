<#
.SYNOPSIS
This analyze script Call akochan reviewer to do batch maj-soul kyoku analyze in local host.

.DESCRIPTION
The akochan reviewer from https://akochan.ekyu.moe/. This script is just a command line interfact batch caller.

.PARAMETER AkochanReviewerFilePath
The mahjong real analyze utility execution file path

.PARAMETER KyokuFilePathList
The MajSoul kyoku data file path list

.EXAMPLE
.\Analyze.ps1 -AkochanReviewerFilePath C:\Path\To\AkochanPortalExecutionFile.exe
    -KyokuFilePathList C:\Path\To\MajSoulKyokuDataA.json,C:\Path\To\MajSoulKyokuDataA.json
#>

param (
    [Parameter(Mandatory=$True, Position=0)]
    [string] $AkochanReviewerFilePath,
    [Parameter(Mandatory=$True, Position=1, ValueFromRemainingArguments)]
    [string[]] $RemainingKyokuArgumentS
)

[string] $akochanReviewerFilePath = $AkochanReviewerFilePath

function IsAkochanReviewerFilePathValid {
    Test-Path -Path $akochanReviewerFilePath -IsValid
}

function IsAkochanReviewerFileExist {
    Test-Path -Path $akochanReviewerFilePath
}

function IsMahjongKyokuDataFilePathValid {
    param (
        [Parameter(Mandatory=$True)]
        [string] $kyokuDataFilePath
    )
    Test-Path -Path $kyokuDataFilePath -IsValid
}

function IsMahjongKyokuActorIndexValid {
    param (
        [Parameter(Mandatory=$True)]
        [string] $actorIndex
    )
    return ($actorIndex -eq '0') -or ($actorIndex -eq '1') -or ($actorIndex -eq '2') -or ($actorIndex -eq '3')
}

function IsMahjongKyokuDataFileExist {
    param (
        [Parameter(Mandatory=$True)]
        [string] $kyokuDataFilePath
    )
    Test-Path -Path $kyokuDataFilePath
}

function PredicatePrerequisteAkochanReviewer {
    if (-not (IsAkochanReviewerFilePathValid)) {
        Write-Host 'The argument AkochanReviewerFilePath invalid'; return $False
    }
    if (-not (IsAkochanReviewerFileExist)) {
        Write-Host "The argument akochan reviewer $akochanReviewerFilePath not exist"; return $False
    }
    return $True
}

function ParseRemainingKyokuArgumentS {
    param (
        [Parameter(Mandatory=$True)]
        [string[]] $argumentS
    )

    if (($argumentS.Count % 2) -eq 1) {
        Write-Host 'The argument remaining kyoku arguments format invalid'; return $null
    }

    $kyokuNumber = $argumentS.Count / 2
    $result = [object[]]::new($kyokuNumber)
    for ($index = 0; $index -lt $kyokuNumber; $index++) {
        $currentKyokuDataFilePath = $argumentS[$index * 2]
        $currentKyokuActorIndex = $argumentS[($index * 2) + 1]
        if (-not (IsMahjongKyokuDataFilePathValid -kyokuDataFilePath $currentKyokuDataFilePath)) {
            Write-Host "The argument kyoku data file path $currentKyokuDataFilePath invalid"; return $null
        }
        if (-not (IsMahjongKyokuDataFileExist -kyokuDataFilePath $currentKyokuDataFilePath)) {
            Write-Host "The kyoku data file $currentKyokuDataFilePath not exist"; return $null
        }
        if (-not (IsMahjongKyokuActorIndexValid -actorIndex $currentKyokuActorIndex)) {
            Write-Host "The argument kyoku actor index $currentKyokuActorIndex invalid"; return $null
        }
        $result[$index] = [System.Tuple]::Create($argumentS[$index * 2], $argumentS[($index * 2) + 1])
    }
    return $result
}

function DoAnalyze {
    param (
        [Parameter(Mandatory=$True)]
        [System.Tuple`2[string, string]] $akochanKyokuArgumentSetS
    )

    $akochanKyokuArgumentSetS |
    ForEach-Object {
        $kyokuDataFilePath = $_.Item1
        $actorIndex = $_.Item2
        $analyzeCommand = ". '$akochanReviewerFilePath' --in-file $kyokuDataFilePath --actor $actorIndex --lang en --without-viewer --deviation-threshold 0.1"
        Write-Host $analyzeCommand
        Invoke-Expression -Command $analyzeCommand
    }
}

function Main {
    if (-not (PredicatePrerequisteAkochanReviewer)) {
        Write-Host 'Aborted'; exit
    }

    $akochanKyokuArgumentSetS = ParseRemainingKyokuArgumentS -argumentS $RemainingKyokuArgumentS
    if ($null -eq $akochanKyokuArgumentSetS) {
        Write-Host 'Aborted'; exit
    }

    $originalWorkingDirectory = Get-Location

    "Start at $(Get-Date)" | Write-Host
    (Get-Item $AkochanReviewerFilePath).Directory.FullName | Set-Location
    DoAnalyze -akochanKyokuArgumentSetS $akochanKyokuArgumentSetS
    Set-Location -Path $originalWorkingDirectory
    "Complete at $(Get-Date)" | Write-Host
}

Main