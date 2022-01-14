<#
.SYNOPSIS
Encode.AvifBatch script do batch encoding jpg/png image files in directory and export to target directory.
The directory hierarchy will be kept.

.DESCRIPTION
Encode.AvifBatch use https://github.com/AOMediaCodec/libavif tools to encoding jpg/png files. The target
directory hierarchy will be kept, some common encoding options can be bypassed to libavif tools.

.PARAMETER EncodingUtilityDirectory
The libavif tool exe file directory, the valid tool named avifenc.exe should existed
.PARAMETER InputDirectory
The input directory including the to be encoding image files.
.PARAMETER OutputDirectory
The output directory to store the avif encoded image files, it should not existed or existed and empty.
.PARAMETER EncoderSpeed
The argument bypass to avifenc -speed.
.PARAMETER EncodingWorkerThreadNumber
The argument bypass to avifenc -jobs.
.PARAMETER YuvFormat
The argument bypass to avifenc -yuv.

.EXAMPLE
.\Encode.AvifBatch.ps1 -EncodingUtilityDirectory C:\Path\To\libavif
	-InputDirectory D:\Path\To\Input -OutputDirectory D:\Path\To\Output
	

.EXAMPLE
.\Encode.AvifBatch.ps1 -EncodingUtilityDirectory C:\Path\To\libavif
	-InputDirectory D:\Path\To\Input -OutputDirectory D:\Path\To\Output
	-EncodingWorkderThreadNumber 4 -EncoderSpeed 4
#>
param (
	[Parameter(Mandatory=$True)]
	[string] $EncodingUtilityDirectory,
	[Parameter(Mandatory=$True)]
	[string] $InputDirectory,
	[Parameter(Mandatory=$True)]
	[string] $OutputDirectory,
	[string] $EncodingWorkerThreadNumber = 1,
	[string] $EncoderSpeed = 0,
	[string] $YuvFormat = 420
)

[string] $inputDirectoryPath = $InputDirectory
[string] $outputDirectoryPath = $OutputDirectory
[string] $encodingUtilityDirectoryPath = $EncodingUtilityDirectory

[string] $encodingExecutionFileName = 'avifenc.exe'
[string] $encodingExecutionFilePath = Join-Path -Path $encodingUtilityDirectoryPath -ChildPath $encodingExecutionFileName

function IsEncodingExecutionFilePathValid {
	Test-Path -Path $encodingExecutionFilePath -IsValid
}

function IsInputDirectoryValid {
	Test-Path -Path $inputDirectoryPath -IsValid
}

function IsOutputDirectoryValid {
	Test-Path -Path $outputDirectoryPath -IsValid
}

function PredicateEncodingExecutionFileExist {
	Test-Path -Path $encodingExecutionFilePath
}

function PredicateInputDirectoryExist {
	Test-Path -Path $inputDirectoryPath
}

function PredicateOutputDirectoryExist {
	Test-Path -Path $outputDirectoryPath
}

function PredicateOutputDirectoryEmpty {
	$directoryInfo = Get-ChildItem $outputDirectoryPath | Measure-Object
	$directoryInfo.Count -eq 0
}

function PredicatePrerequiste {
	if (-not (IsEncodingExecutionFilePathValid)) {
		Write-Host 'The argument EncodingUtilityDirectory invalid'; return $False
	}
	if (-not (IsInputDirectoryValid)) {
		Write-Host 'The argument InputDirectory invalid'; return $False
	}
	if (-not (IsOutputDirectoryValid)) {
		Write-Host 'The argument OutputDirectory invalid'; return $False
	}
	if (-not (PredicateEncodingExecutionFileExist)) {
		Write-Host "The encoding execution file $encodingExecutionFilePath not exist"; return $False
	}
	if (-not (PredicateInputDirectoryExist)) {
		Write-Host "The input directory $inputDirectoryPath not exist"; return $False
	}
	if ((PredicateOutputDirectoryExist) -and (-not (PredicateOutputDirectoryEmpty))) {
		Write-Host "The output directory $outputDirectoryPath exist and not empty, abort in case of overwritten"; return $False
	}
	return $True
}

function GetProgressTaskNumberTotal {
	Get-ChildItem -Path $inputDirectoryPath -File -Recurse |
	Where-Object { $_.name -like '*.jpg' -or $_.name -like '*.png' } |
	Measure-Object |
	Select-Object -ExpandProperty Count
}

[int] $progressTaskProgressSequenceNumber = 1
[int] $progressTaskNumberTotal = GetProgressTaskNumberTotal
[int] $progressFormatNumberWidth = $progressTaskNumberTotal.ToString().Length
[string] $progressTaskProgressFormat = "{0,$progressFormatNumberWidth}"

function DoEncodingChildDirectory {
	param (
		[Parameter(Mandatory=$True)]
		[string] $inputDirectoryPath,
		[Parameter(Mandatory=$True)]
		[string] $outputDirectoryPath
	)

	if (-not (Test-Path -Path $outputDirectoryPath)) {
		New-Item -Path $outputDirectoryPath -ItemType Directory | Out-Null
		Write-Host "New directory $outputDirectoryPath created"
	}

	Get-ChildItem -Path $inputDirectoryPath -File -Recurse |
	Where-Object { $_.name -like '*.jpg' -or $_.name -like '*.png'} |
	ForEach-Object {
		$fromFilePath = $_.FullName
		$relativeFilePath = [IO.Path]::GetRelativePath($inputDirectoryPath, $fromFilePath)
		$relativeFilePathWithoutFileNameExtension = $relativeFilePath.Substring(0, $relativeFilePath.Length - 4)
		$toFilePath = `
			"$relativeFilePathWithoutFileNameExtension.avif" |
			Select-Object @{name='ChildPath';expression={$_}} |
			Join-Path -Path $outputDirectoryPath
		$encodeFileCommand =
			"$encodingExecutionFilePath" +`
			" --depth 8 --yuv $YuvFormat --speed $EncoderSpeed --jobs $EncodingWorkerThreadNumber" +`
			" $fromFilePath $toFilePath"
		$progressSequenceNumberText = $progressTaskProgressFormat -f $progressTaskProgressSequenceNumber
		#Write-Host $encodeFileCommand
		Write-Host "[$progressSequenceNumberText/$progressTaskNumberTotal] $relativeFilePath"
		Invoke-Expression -Command $encodeFileCommand | Out-Null
		$progressTaskProgressSequenceNumber = $progressTaskProgressSequenceNumber + 1
	} |
	Out-Null
}

function DoEncoding {
	DoEncodingChildDirectory `
		-inputDirectoryPath $inputDirectoryPath -outputDirectoryPath $outputDirectoryPath

	Get-ChildItem -Path $inputDirectoryPath -Directory -Recurse |
	Select-Object -Expand FullName |
	ForEach-Object {
		$childInputDirectoryPath = $_
		$relativeChildDirectoryPath = [IO.Path]::GetRelativePath($inputDirectoryPath, $_)
		$childOutputDirectoryPath = Join-Path -Path $outputDirectoryPath -ChildPath $relativeChildDirectoryPath
		DoEncodingChildDirectory `
			-inputDirectoryPath $childInputDirectoryPath -outputDirectoryPath $childOutputDirectoryPath
	}
}

function CreateOutputDirectoryIfNotExist {
	if (-not (PredicateOutputDirectoryExist)) {
		New-Item -Path $outputDirectoryPath -ItemType Directory
		Write-Host "The output directory $outputDirectoryPath created"
	}
}

function Main {
	if (-not (PredicatePrerequiste)) {
		Write-Host 'Aborted'; exit
	}

	"Start at $(Get-Date)" | Write-Host
	CreateOutputDirectoryIfNotExist
	DoEncoding
	"Complete at $(Get-Date)" | Write-Host
}

Main
