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
.\GameMahjong.Analyze.ps1 -AkochanReviewerFilePath C:\Path\To\AkochanPortalExecutionFile.exe
    -KyokuFilePathList C:\Path\To\MajSoulKyokuDataA.json,C:\Path\To\MajSoulKyokuDataA.json
#>

param (
    [Parameter(Mandatory=$True)]
    [string[]] $KyokuDataFilePathList,
    [Parameter(Mandatory=$True)]
    [string] $AkochanReviewerFilePath
)

[string] $akochanReviewerFilePath = $AkochanReviewerFilePath
[string[]] $kyokuDataFilePathS = $KyokuDataFilePathList

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

function PredicatePrerequisteMahjongKyokuData {
    $kyokuDataFilePathS |
    ForEach-Object {
        if (-not (IsMahjongKyokuDataFilePathValid -kyokuDataFilePath $_)) {
            Write-Host 'The argument KyokuFilePathList contains some invalid file path'; return $False
        }
        if (-not (IsMahjongKyokuDataFileExist -kyokuDataFilePath $_)) {
            Write-Host "The argument kyoku data file $_ not exist"; return $False
        }
    }
    return $True
}

function DoAnalyze {
    $kyokuDataFilePathS |
    ForEach-Object {
        $analyzeCommand = ". '$akochanReviewerFilePath' --actor 3 --in-file $_ --lang en"
        Invoke-Expression -Command $analyzeCommand
    }
}

function Main {
    if (-not (PredicatePrerequisteAkochanReviewer)) {
        Write-Host 'Aborted'; exit
    }
    if (-not (PredicatePrerequisteMahjongKyokuData)) {
        Write-Host 'Aborted'; exit
    }

    $originalWorkingDirectory = Get-Location

    "Start at $(Get-Date)" | Write-Host
    (Get-Item $AkochanReviewerFilePath).Directory.FullName | Set-Location
    DoAnalyze
    Set-Location -Path $originalWorkingDirectory
    "Complete at $(Get-Date)" | Write-Host
}

Main
