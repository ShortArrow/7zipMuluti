Param(
    [Parameter()]
    [ValidatePattern("[a-zA-Z0-9@!$%&=\-^~|_/?><.,+;:*}{]+")]
    [SecureString]
    $Password   
)
. .\Select-Folder.ps1

# Set-PSDebug -Trace 0
$7zpath="C:\Program Files\7-Zip\7z.exe"
$x001=(Get-ChildItem)
[System.IO.FileInfo]$y001
foreach ($y001 in $x001) {
    if (("",".ps1",".cmd",".zip",".7z") -notcontains $y001.Extension -and !($y001.PSIsContainer) -and ($y001.Extension -ne $y001.Name)) {
        $z001=$(Join-Path $y001.Directory $($([System.IO.Path]::GetFileNameWithoutExtension("`"$y001`""))+".7z"))
        if ($Password -eq $null) {
            Start-Process -FilePath $7zpath -ArgumentList 'a', "-t7z", "`"$z001`"", "`"$y001`"" -NoNewWindow
        }else {
            Start-Process -FilePath $7zpath -ArgumentList 'a', "-t7z", "`"$z001`"", "-p"$Password, "-mhe", "`"$y001`"" -NoNewWindow
        }
        Write-Host $z001" <-- "$y001
    }
}

# Write-Host $x001[0].GetType()