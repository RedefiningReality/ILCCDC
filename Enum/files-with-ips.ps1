$searchRegex = "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"
$outFile = "C:\results.txt"

$directories = @("C:\Program Files", "C:\Program Files (x86)", "C:\Users", "C:\Icow")
foreach ($dirPath in $directories) {
    if (Test-Path $dirPath) {
        Get-ChildItem -Path $dirPath -Recurse -File | ForEach-Object {
            $filePath = $_.FullName
            $fileContents = Get-Content $filePath
            for ($i = 0; $i -lt $fileContents.Length; $i++) {
                if ($fileContents[$i] -match $searchRegex) {
                    $matchText = "{0}:{1}:{2}" -f $filePath, ($i + 1), $Matches[0]
                    Out-File -FilePath $outFile -Append -InputObject $matchText
                }
            }
        }
    }
}
