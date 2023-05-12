$path = ""
$outpath = ""
$outputfile = ".csv"


$array = get-childitem $path -filter *.zip | Select-Object FullName

$array | Export-Csv -Path "$outpath/$outputfile" -NoTypeInformation -Delimiter ";"