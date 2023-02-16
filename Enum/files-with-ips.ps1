$searchRegex = "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"
$outFile = "C:\results.txt"

$directories = @("C:\Program Files", "C:\Program Files (x86)", "C:\Users", "C:\Icow")

$totalFileCount = 0
$totalByteCount = 0

# Get total file count and byte count to display progress bar
foreach ($dirPath in $directories) {
    if (Test-Path $dirPath) {
        $dirStats = Get-ChildItem -Path $dirPath -Recurse -File -Force | Measure-Object -Property Length -Sum
        $totalFileCount += (Get-ChildItem -Path $dirPath -Recurse -File -Force).Count
        $totalByteCount += $dirStats.Sum
    }
}

$completedFileCount = 0
$completedByteCount = 0

# Loop through directories and files to search for the regex pattern
foreach ($dirPath in $directories) {
    if (Test-Path $dirPath) {
        Get-ChildItem -Path $dirPath -Recurse -File -Force | ForEach-Object -Parallel {
            $filePath = $_.FullName
            $fileLength = $_.Length
            $fileContents = Get-Content $filePath -Raw
            $matches = Select-String -InputObject $fileContents -Pattern $searchRegex -AllMatches
            foreach ($match in $matches) {
                $matchText = "{0}:{1}:{2}" -f $filePath, ($match.LineNumber), $match.Matches[0].Value
                Out-File -FilePath $outFile -Append -InputObject $matchText
            }
            $completedFileCount++
            $completedByteCount += $fileLength
            $percentComplete = ($completedByteCount / $totalByteCount) * 100
            Write-Progress -Activity "Searching for regex pattern in files" -Status "Processing file $($filePath)" -PercentComplete $percentComplete -CurrentOperation "File $($completedFileCount) of $($totalFileCount)" -SecondsRemaining (($totalByteCount - $completedByteCount) / ($completedByteCount / (Get-Date).Subtract($startTime).TotalSeconds))
        }
    }
}
