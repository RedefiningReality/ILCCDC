$searchRegex = "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"
$outFile = "C:\results.txt"

$directories = @("C:\Program Files", "C:\Program Files (x86)", "C:\Users", "C:\Icow")
foreach ($dirPath in $directories) {
    if (Test-Path $dirPath) {
        Get-ChildItem -Path $dirPath -Recurse -File | ForEach-Object -Parallel {
            $filePath = $_.FullName
            $fileContents = Get-Content $filePath -Raw
            $matches = Select-String -InputObject $fileContents -Pattern $searchRegex -AllMatches
            foreach ($match in $matches) {
                $matchText = "{0}:{1}:{2}" -f $filePath, ($match.LineNumber), $match.Matches[0].Value
                Out-File -FilePath $outFile -Append -InputObject $matchText
            }
        }
    }
}
