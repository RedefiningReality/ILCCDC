# Define the directories to search
$dirsToSearch = @("C:\Program Files", "C:\Program Files (x86)", "C:\Users", "C:\Icow")

# Define the regular expression to search for
$regex = "(?<!\d|\.)(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(?!\d|\.)"

# Loop through each directory and search for matching files
$dirsToSearch | ForEach-Object {
    $dir = $_
    if(Test-Path $dir -PathType Container){
        Get-ChildItem -Path $dir -Recurse -File | ForEach-Object {
            $filePath = $_.FullName
            Get-Content $filePath | Select-String $regex -AllMatches | ForEach-Object {
                $_.Matches | ForEach-Object {
                    $lineNumber = $_.LineNumber
                    $ipAddress = $_.Value
                    $output = "{0}: {1}: {2}" -f $filePath, $lineNumber, $ipAddress
                    $output | Tee-Object -FilePath "C:\results.txt" -Append
                    Write-Host $output
                }
            }
        }
    }
}
