Clear-Host
$Error.Clear()
$ErrorActionPreference="Continue"
$VerbosePreference="continue"

$jsonPath = $($MyInvocation.MyCommand.path) -replace "ps1", "json"

$conf= Get-Content $jsonPath | Out-String | ConvertFrom-Json -Verbose

#per far funzionare il merge, ti serve il file itextsharp.dll!!
function Merge-pdf(){
    [CmdletBinding()]
    param(
        [string]$workingDirectory,
        [string]$fileOutPut
    )

    [void] [System.Reflection.Assembly]::LoadFrom($conf.itextsharp.dllpath)
    $pdfs = Get-ChildItem $workingDirectory -recurse | Where-Object {-not $_.PSIsContainer -and $_.Extension -imatch "^\.pdf$"};
    $output = $fileOutPut
    $fileStream = New-Object System.IO.FileStream($output, [System.IO.FileMode]::OpenOrCreate);
    $document = New-Object iTextSharp.text.Document;
    $pdfCopy = New-Object iTextSharp.text.pdf.PdfCopy($document, $fileStream);
    $document.Open();
    [iTextSharp.text.pdf.PdfReader]::unethicalreading=$true
    foreach ($pdf in $pdfs) {
        Write-Verbose "Adding pdf $($pdf.name) into $fileOutPut"
        $reader = New-Object iTextSharp.text.pdf.PdfReader($pdf.FullName);
        
        $pdfCopy.AddDocument($reader);
        $reader.Dispose();  
    }

    $pdfCopy.Dispose();
    $document.Dispose();
    $fileStream.Dispose();
}



#per far funzionare l'applicativo, occorre che i singoli pdf abbiano il campo nomedocumentopdf in comune!!

$scratchDir=$conf.folders.workdir

if (-not (Test-Path $scratchDir)){
    mkdir $scratchDir | Out-Null
}

Get-ChildItem $scratchDir -Directory | ForEach-Object {
        Push-Location $($_.FullName)
        $pdfs= Get-ChildItem -Directory
        foreach ($d in $pdfs){
           $outputPdf="$($d.FullName).pdf"
           Write-Verbose $outputPdf
           Merge-pdf -workingDirectory $d.FullName -fileOutPut $outputPdf
           Remove-Item $d.FullName -Recurse
        }
        Pop-Location 
    }


$scratchDir

$outputPdf

