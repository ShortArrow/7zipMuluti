# Set-PSDebug -Trace 0
$7zpath="C:\Program Files\7-Zip\7z.exe"
$x001=(Get-ChildItem)
[System.IO.FileInfo]$y001
foreach ($y001 in $x001) {
    if (("",".ps1",".cmd",".zip",".7z") -notcontains $y001.Extension -and !($y001.PSIsContainer)) {
        $z001=$(Join-Path $y001.Directory $($([System.IO.Path]::GetFileNameWithoutExtension("`"$y001`""))+".zip"))
        Start-Process -FilePath $7zpath -ArgumentList 'a', "-tzip", "`"$z001`"", "`"$y001`""
        Write-Host $(Join-Path $y001.Directory $($([System.IO.Path]::GetFileNameWithoutExtension($y001))+".zip"))
        
    }
}

# Write-Host $x001[0].GetType()