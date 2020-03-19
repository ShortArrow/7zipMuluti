Param(
    [Parameter()]
    [switch]
    $NeedPassword,
    [Parameter()]
    [switch]
    $zip
    )

function [SecureString]myInputBox {
    param (
    )

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing

    $form = New-Object System.Windows.Forms.Form
    $form.Text = '7zipMuluti'
    $form.Size = New-Object System.Drawing.Size(300,200)
    $form.StartPosition = 'CenterScreen'

    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75,120)
    $okButton.Size = New-Object System.Drawing.Size(75,23)
    $okButton.Text = 'OK'
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $form.AcceptButton = $okButton
    $form.Controls.Add($okButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150,120)
    $cancelButton.Size = New-Object System.Drawing.Size(75,23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $form.CancelButton = $cancelButton
    $form.Controls.Add($cancelButton)

    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(10,20)
    $label.Size = New-Object System.Drawing.Size(280,20)
    $label.Text = 'Please type a password'
    $form.Controls.Add($label)

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point(10,40)
    $textBox.Size = New-Object System.Drawing.Size(260,20)
    $form.Controls.Add($textBox)

    $form.Topmost = $true

    $form.Add_Shown({$textBox.Select()})
    $result = $form.ShowDialog()

    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $x = $textBox.Text
        return $x
    }
}
. .\Select-Folder.ps1
# Set-PSDebug -Trace 0
$7zpath="C:\Program Files\7-Zip\7z.exe"
$x001=(Get-ChildItem)
[securestring]$Password
if ($NeedPassword) {
    $Password = myInputBox
}

[System.IO.FileInfo]$y001
foreach ($y001 in $x001) {
    if (("",".ps1",".cmd",".zip",".7z") -notcontains $y001.Extension -and !($y001.PSIsContainer) -and ($y001.Extension -ne $y001.Name)) {
        $z001=$(Join-Path $y001.Directory $($([System.IO.Path]::GetFileNameWithoutExtension("`"$y001`""))+".7z"))
        if ($null -eq $Password) {
            Start-Process -FilePath $7zpath -ArgumentList 'a', "-t7z", "`"$z001`"", "`"$y001`"" -NoNewWindow
        }else {
            Start-Process -FilePath $7zpath -ArgumentList 'a', "-t7z", "`"$z001`"", "-p"$Password, "-mhe", "`"$y001`"" -NoNewWindow
        }
        Write-Host $z001" <-- "$y001
    }
}

# Write-Host $x001[0].GetType()
