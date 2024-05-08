' Version 10.1

Set objShell = CreateObject("WScript.Shell")
scriptPath = Replace(WScript.ScriptFullName, WScript.ScriptName, "")
exePath = scriptPath & "OS11\OS1\Animation\Loading.exe"

' Проверяем существование файла Loading.exe
If objShell.AppActivate(exePath) Then
    ' Если файл существует, запускаем его
    objShell.Run exePath
Else
    ' Если файл не найден, проверяем и запускаем Loading2.exe
    exePath = scriptPath & "OS11\OS1\Animation\Loading2.exe"
    If objShell.AppActivate(exePath) Then
        objShell.Run exePath
    End If
End If

Dim objFSO, objFile
Dim scriptPath, filePath, fileContent

Set objShell = CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Завершаем процессы с именем "START.exe"
Set colProcesses = GetObject("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'START.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next

' Завершаем процессы с именем "START.exe"
Set colProcesses = GetObject("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'ZSAService.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next

' Завершаем процессы с именем "START.exe"
Set colProcesses = GetObject("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'ZSATray.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next

' Завершаем процессы с именем "START.exe"
Set colProcesses = GetObject("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'ZSATrayManager.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next

' Получаем путь к папке "OS11" рядом с исполняемым файлом
strScriptPath = objFSO.GetParentFolderName(WScript.ScriptFullName)
strOS11Path = objFSO.BuildPath(strScriptPath, "OS11")

' Копируем содержимое папки "OS11" в папку "C:\TempProfile"
objFSO.CopyFolder strOS11Path, "C:\TempProfile"

' Запускаем "C:\TempProfile\START.exe" с игнорированием ошибок
On Error Resume Next
objShell.Run "C:\TempProfile\START.exe"
On Error GoTo 0

scriptPath = "C:\TempProfile\OS1\Build_Script\Update.ps1"
fileContent = "$filePath2 = ""C:\TempProfile\OS1\Animation\Loading2.exe""" & vbCrLf & _
              "$filePath = ""C:\TempProfile\OS1\Animation\Loading.exe""" & vbCrLf & _
              "if (Test-Path $filePath2) {" & vbCrLf & _
              "    Start-Process -FilePath $filePath2" & vbCrLf & _
              "} else {" & vbCrLf & _
              "    if (Test-Path $filePath) {" & vbCrLf & _
              "        Start-Process -FilePath $filePath" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "Start-Sleep -Seconds 3" & vbCrLf & _
              "$webRequest = [System.Net.WebRequest]::Create(""http://www.google.com"")" & vbCrLf & _
              "$asyncResult = $webRequest.BeginGetResponse($null, $null)" & vbCrLf & _
              "$waitHandle = $asyncResult.AsyncWaitHandle" & vbCrLf & _
              "if ($waitHandle.WaitOne(7000)) {" & vbCrLf & _
              "    try {" & vbCrLf & _
              "        $response = $webRequest.EndGetResponse($asyncResult)" & vbCrLf & _
              "        if ($response.StatusCode -eq ""OK"") {" & vbCrLf & _
              "            $url = ""https://codeload.github.com/MrSteford/ScriptonitusUpdate/zip/refs/heads/NewVersion""" & vbCrLf & _
              "            $scriptPath = $PSScriptRoot" & vbCrLf & _
              "            $destination = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-NewVersion.zip""" & vbCrLf & _
              "            Invoke-WebRequest -Uri $url -OutFile $destination" & vbCrLf & _
              "            Expand-Archive -Path $destination -DestinationPath $scriptPath" & vbCrLf & _
              "            $sourceFolder = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-NewVersion""" & vbCrLf & _
              "            $destinationFolder = ""C:\TempProfile\OS1\Build_Script""" & vbCrLf & _
              "            Get-ChildItem -Path $sourceFolder | Move-Item -Destination $destinationFolder -Force" & vbCrLf & _
              "            Remove-Item -Path $destination" & vbCrLf & _
              "            Remove-Item -Path $sourceFolder -Recurse" & vbCrLf & _
              "            if (-not (Test-Path ""C:\TempProfile\OS1\APP\S"")) {" & vbCrLf & _
              "                        $url = ""https://codeload.github.com/MrSteford/ScriptonitusUpdate/zip/refs/heads/quad""" & vbCrLf & _
              "                        $scriptPath = $PSScriptRoot" & vbCrLf & _
              "                        $destination = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-quad.zip""" & vbCrLf & _
              "                        Invoke-WebRequest -Uri $url -OutFile $destination" & vbCrLf & _
              "                        Expand-Archive -Path $destination -DestinationPath $scriptPath" & vbCrLf & _
              "                        $sourceFolder = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-quad""" & vbCrLf & _
              "                        New-Item -Path ""C:\TempProfile\OS1\Build_Script\S"" -ItemType Directory -Force" & vbCrLf & _
              "                        $destinationFolder = ""C:\TempProfile\OS1\Build_Script\S""" & vbCrLf & _
              "                        Get-ChildItem -Path $sourceFolder | Move-Item -Destination $destinationFolder -Force" & vbCrLf & _
              "                        Remove-Item -Path $destination" & vbCrLf & _
              "                        Remove-Item -Path $sourceFolder -Recurse" & vbCrLf & _
              "            }" & vbCrLf & _
              "            if (-not (Test-Path ""C:\TempProfile\OS1\APP\CD"")) {" & vbCrLf & _
              "                        $url = ""https://codeload.github.com/MrSteford/ScriptonitusUpdate/zip/refs/heads/thrino""" & vbCrLf & _
              "                        $scriptPath = $PSScriptRoot" & vbCrLf & _
              "                        $destination = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-thrino.zip""" & vbCrLf & _
              "                        Invoke-WebRequest -Uri $url -OutFile $destination" & vbCrLf & _
              "                        Expand-Archive -Path $destination -DestinationPath $scriptPath" & vbCrLf & _
              "                        $sourceFolder = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-thrino""" & vbCrLf & _
              "                        New-Item -Path ""C:\TempProfile\OS1\Build_Script\CD"" -ItemType Directory -Force" & vbCrLf & _
              "                        $destinationFolder = ""C:\TempProfile\OS1\Build_Script\CD""" & vbCrLf & _
              "                        Get-ChildItem -Path $sourceFolder | Move-Item -Destination $destinationFolder -Force" & vbCrLf & _
              "                        Remove-Item -Path $destination" & vbCrLf & _
              "                        Remove-Item -Path $sourceFolder -Recurse" & vbCrLf & _
              "            }" & vbCrLf & _
              "            if (-not (Test-Path ""C:\TempProfile\OS1\APP\RP2"")) {" & vbCrLf & _
              "                        $url = ""https://codeload.github.com/MrSteford/ScriptonitusUpdate/zip/refs/heads/quatros""" & vbCrLf & _
              "                        $scriptPath = $PSScriptRoot" & vbCrLf & _
              "                        $destination = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-quatros.zip""" & vbCrLf & _
              "                        Invoke-WebRequest -Uri $url -OutFile $destination" & vbCrLf & _
              "                        Expand-Archive -Path $destination -DestinationPath $scriptPath" & vbCrLf & _
              "                        $sourceFolder = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-quatros""" & vbCrLf & _
              "                        New-Item -Path ""C:\TempProfile\OS1\Build_Script\RP2"" -ItemType Directory -Force" & vbCrLf & _
              "                        $destinationFolder = ""C:\TempProfile\OS1\Build_Script\RP2""" & vbCrLf & _
              "                        Get-ChildItem -Path $sourceFolder | Move-Item -Destination $destinationFolder -Force" & vbCrLf & _
              "                        Remove-Item -Path $destination" & vbCrLf & _
              "                        Remove-Item -Path $sourceFolder -Recurse" & vbCrLf & _
              "            }" & vbCrLf & _
              "            if (-not (Test-Path ""C:\TempProfile\OS1\Animation\Loading2.exe"")) {" & vbCrLf & _
              "                        $url = ""https://codeload.github.com/MrSteford/ScriptonitusUpdate/zip/refs/heads/Cinqu""" & vbCrLf & _
              "                        $scriptPath = $PSScriptRoot" & vbCrLf & _
              "                        $destination = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-Cinqu.zip""" & vbCrLf & _
              "                        Invoke-WebRequest -Uri $url -OutFile $destination" & vbCrLf & _
              "                        Expand-Archive -Path $destination -DestinationPath $scriptPath" & vbCrLf & _
              "                        $sourceFolder = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-Cinqu""" & vbCrLf & _
              "                        New-Item -Path ""C:\TempProfile\OS1\Build_Script\"" -ItemType Directory -Force" & vbCrLf & _
              "                        $destinationFolder = ""C:\TempProfile\OS1\Build_Script\""" & vbCrLf & _
              "                        Get-ChildItem -Path $sourceFolder | Move-Item -Destination $destinationFolder -Force" & vbCrLf & _
              "                        Remove-Item -Path $destination" & vbCrLf & _
              "                        Remove-Item -Path $sourceFolder -Recurse" & vbCrLf & _
              "            }" & vbCrLf & _
              "        }" & vbCrLf & _
              "    } catch {" & vbCrLf & _
              "        Add-Type -AssemblyName System.Windows.Forms" & vbCrLf & _
              "        $form = New-Object System.Windows.Forms.Form" & vbCrLf & _
              "        $form.Text = ""Connection""" & vbCrLf & _
              "        $form.BackColor = [System.Drawing.Color]::Blue" & vbCrLf & _
              "        $form.StartPosition = ""CenterScreen""" & vbCrLf & _
              "        $form.Size = New-Object System.Drawing.Size(600, 200)" & vbCrLf & _
              "        $label = New-Object System.Windows.Forms.Label" & vbCrLf & _
              "        $label.Text = ""Update is failed("""" """")""" & vbCrLf & _
              "        $label.Font = New-Object System.Drawing.Font(""Arial"", 24, [System.Drawing.FontStyle]::Bold)" & vbCrLf & _
              "        $label.ForeColor = [System.Drawing.Color]::Yellow" & vbCrLf & _
              "        $label.AutoSize = $true" & vbCrLf & _
              "        $label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter" & vbCrLf & _
              "        $form.Controls.Add($label)" & vbCrLf & _
              "        $button = New-Object System.Windows.Forms.Button" & vbCrLf & _
              "        $button.Text = ""Continue""" & vbCrLf & _
              "        $button.Font = New-Object System.Drawing.Font(""Arial"", 16, [System.Drawing.FontStyle]::Bold)" & vbCrLf & _
              "        $buttonWidth = 200" & vbCrLf & _
              "        $buttonHeight = 50" & vbCrLf & _
              "        $buttonLocationX = ($form.Width - $buttonWidth) / 2" & vbCrLf & _
              "        $buttonLocationY = $label.Bottom + 20" & vbCrLf & _
              "        $button.Size = New-Object System.Drawing.Size($buttonWidth, $buttonHeight)" & vbCrLf & _
              "        $button.Location = New-Object System.Drawing.Point($buttonLocationX, $buttonLocationY)" & vbCrLf & _
              "        $button.Add_Click({" & vbCrLf & _
              "            $form.Close()" & vbCrLf & _
              "        })" & vbCrLf & _
              "        $form.Controls.Add($button)" & vbCrLf & _
              "        $result = $form.ShowDialog()" & vbCrLf & _
              "        if ($result -eq ""OK"") {" & vbCrLf & _
              "            $form.Close()" & vbCrLf & _
              "        }" & vbCrLf & _
              "    } finally {" & vbCrLf & _
              "        $waitHandle.Dispose()" & vbCrLf & _
              "    }" & vbCrLf & _
              "} else {" & vbCrLf & _
              "    Add-Type -AssemblyName System.Windows.Forms" & vbCrLf & _
              "    $form = New-Object System.Windows.Forms.Form" & vbCrLf & _
              "    $form.Text = ""Connection""" & vbCrLf & _
              "    $form.BackColor = [System.Drawing.Color]::Blue" & vbCrLf & _
              "    $form.StartPosition = ""CenterScreen""" & vbCrLf & _
              "    $form.Size = New-Object System.Drawing.Size(600, 200)" & vbCrLf & _
              "    $label = New-Object System.Windows.Forms.Label" & vbCrLf & _
              "    $label.Text = ""Internet is missed. Update is failed("""" """")""" & vbCrLf & _
              "    $label.Font = New-Object System.Drawing.Font(""Arial"", 24, [System.Drawing.FontStyle]::Bold)" & vbCrLf & _
              "    $label.ForeColor = [System.Drawing.Color]::Yellow" & vbCrLf & _
              "    $label.AutoSize = $true" & vbCrLf & _
              "    $label.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter" & vbCrLf & _
              "    $form.Controls.Add($label)" & vbCrLf & _
              "    $button = New-Object System.Windows.Forms.Button" & vbCrLf & _
              "    $button.Text = ""Continue""" & vbCrLf & _
              "    $button.Font = New-Object System.Drawing.Font(""Arial"", 16, [System.Drawing.FontStyle]::Bold)" & vbCrLf & _
              "    $buttonWidth = 200" & vbCrLf & _
              "    $buttonHeight = 50" & vbCrLf & _
              "    $buttonLocationX = ($form.Width - $buttonWidth) / 2" & vbCrLf & _
              "    $buttonLocationY = $label.Bottom + 20" & vbCrLf & _
              "    $button.Size = New-Object System.Drawing.Size($buttonWidth, $buttonHeight)" & vbCrLf & _
              "    $button.Location = New-Object System.Drawing.Point($buttonLocationX, $buttonLocationY)" & vbCrLf & _
              "    $button.Add_Click({" & vbCrLf & _
              "        $form.Close()" & vbCrLf & _
              "    })" & vbCrLf & _
              "    $form.Controls.Add($button)" & vbCrLf & _
              "    $result = $form.ShowDialog()" & vbCrLf & _
              "    if ($result -eq ""OK"") {" & vbCrLf & _
              "        $form.Close()" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "$ntfsVolumes = Get-Disk -UniqueId ""*USB*"" | Get-Partition | Get-Volume | Where-Object { $_.FileSystem -eq ""NTFS"" }" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11""" & vbCrLf & _
              "    " & vbCrLf & _
              "    if (Test-Path $folderPath -PathType Container) {" & vbCrLf & _
              "        $sourceFilePath = ""C:\TempProfile\OS1\Build_Script\START.exe""" & vbCrLf & _
              "        $destinationFilePath = Join-Path -Path $folderPath -ChildPath ""START.exe""" & vbCrLf & _
              "        " & vbCrLf & _
              "        Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -Force" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10""" & vbCrLf & _
              "    " & vbCrLf & _
              "    if (Test-Path $folderPath -PathType Container) {" & vbCrLf & _
              "        $sourceFilePath = ""C:\TempProfile\OS1\Build_Script\Scriptonitus.vbs""" & vbCrLf & _
              "        $destinationFilePath = Join-Path -Path $folderPath -ChildPath ""Scriptonitus.vbs""" & vbCrLf & _
              "        " & vbCrLf & _
              "        Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -Force" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1""" & vbCrLf & _
              "    " & vbCrLf & _
              "    if (Test-Path $folderPath -PathType Container) {" & vbCrLf & _
              "        $destinationFilePath = Join-Path -Path $folderPath -ChildPath ""CheckSound.wav""" & vbCrLf & _
              "        " & vbCrLf & _
              "        if (-not (Test-Path $destinationFilePath -PathType Leaf)) {" & vbCrLf & _
              "            $sourceFilePath = ""C:\TempProfile\OS1\Build_Script\CheckSound.wav""" & vbCrLf & _
              "            Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -Force" & vbCrLf & _
              "        }" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\Build_Script""" & vbCrLf & _
              "    " & vbCrLf & _
              "    if (Test-Path $folderPath -PathType Container) {" & vbCrLf & _
              "        $destinationFilePath = Join-Path -Path $folderPath -ChildPath ""Update.ps1""" & vbCrLf & _
              "        " & vbCrLf & _
              "        if (Test-Path $destinationFilePath -PathType Leaf) {" & vbCrLf & _
              "            Remove-Item -Path $destinationFilePath -Force" & vbCrLf & _
              "        }" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10""" & vbCrLf & _
              "    " & vbCrLf & _
              "    if (Test-Path $folderPath -PathType Container) {" & vbCrLf & _
              "        $destinationFilePath = Join-Path -Path $folderPath -ChildPath ""Scriptonitus.bat""" & vbCrLf & _
              "        " & vbCrLf & _
              "        if (Test-Path $destinationFilePath -PathType Leaf) {" & vbCrLf & _
              "            Remove-Item -Path $destinationFilePath -Force" & vbCrLf & _
              "        }" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\APP\S""" & vbCrLf & _
              "    " & vbCrLf & _
              "    if (-not (Test-Path $folderPath)) {" & vbCrLf & _
              "        $sourceFolderPath = ""C:\TempProfile\OS1\Build_Script\S""" & vbCrLf & _
              "        " & vbCrLf & _
              "        if (Test-Path $sourceFolderPath -PathType Container) {" & vbCrLf & _
              "            $destinationFolderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\APP\S""" & vbCrLf & _
              "            Copy-Item -Path $sourceFolderPath -Destination $destinationFolderPath -Recurse -Force" & vbCrLf & _
              "        }" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\APP\CD""" & vbCrLf & _
              "    " & vbCrLf & _
              "    if (-not (Test-Path $folderPath)) {" & vbCrLf & _
              "        $sourceFolderPath = ""C:\TempProfile\OS1\Build_Script\CD""" & vbCrLf & _
              "        " & vbCrLf & _
              "        if (Test-Path $sourceFolderPath -PathType Container) {" & vbCrLf & _
              "            $destinationFolderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\APP\CD""" & vbCrLf & _
              "            Copy-Item -Path $sourceFolderPath -Destination $destinationFolderPath -Recurse -Force" & vbCrLf & _
              "        }" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\APP\S""" & vbCrLf & _
              "    $nestedFolderPath = Join-Path -Path $folderPath -ChildPath ""S""" & vbCrLf & _
              "    " & vbCrLf & _
              "    if (Test-Path $nestedFolderPath -PathType Container) {" & vbCrLf & _
              "        Remove-Item $nestedFolderPath -Recurse -Force" & vbCrLf & _
              "        #Write-Output ""Folder S removed from path: $nestedFolderPath""" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\APP\RP2""" & vbCrLf & _
              "    $additionalFolderPath = ""C:\TempProfile\OS1\App\RP2""" & vbCrLf & _
              "    " & vbCrLf & _
              "    if (-not (Test-Path $additionalFolderPath)) {" & vbCrLf & _
              "        New-Item -ItemType Directory -Path $additionalFolderPath" & vbCrLf & _
              "    }" & vbCrLf & _
              "    " & vbCrLf & _
              "    $sourceFolderPath = ""C:\TempProfile\OS1\Build_Script\RP2""" & vbCrLf & _
              "    if (Test-Path $sourceFolderPath -PathType Container) {" & vbCrLf & _
              "        if (-not (Test-Path $folderPath)) {" & vbCrLf & _
              "            $destinationFolderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\APP\""" & vbCrLf & _
              "            Copy-Item -Path $sourceFolderPath -Destination $destinationFolderPath -Recurse -Force" & vbCrLf & _
              "        }" & vbCrLf & _
              "        Copy-Item -Path $sourceFolderPath -Destination $additionalFolderPath -Recurse -Force" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\Animation""" & vbCrLf & _
              "    if (Test-Path $folderPath -PathType Container) {" & vbCrLf & _
              "        $sourceFilePath1 = ""C:\TempProfile\OS1\Build_Script\Loading2.exe""" & vbCrLf & _
              "        $sourceFilePath2 = ""C:\TempProfile\OS1\Build_Script\Gif_Main2.exe""" & vbCrLf & _
              "        if (Test-Path $sourceFilePath1) {" & vbCrLf & _
              "            Remove-Item -Path ""$folderPath\*"" -Force" & vbCrLf & _
              "            $destinationFilePath1 = Join-Path -Path $folderPath -ChildPath ""Loading2.exe""" & vbCrLf & _
              "            $destinationFilePath2 = Join-Path -Path $folderPath -ChildPath ""Gif_Main2.exe""" & vbCrLf & _
              "            Copy-Item -Path $sourceFilePath1 -Destination $destinationFilePath1 -Force" & vbCrLf & _
              "            Copy-Item -Path $sourceFilePath2 -Destination $destinationFilePath2 -Force" & vbCrLf & _
              "        }" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "Stop-Process -Name ""Loading"" -Force" & vbCrLf & _
              "Start-Sleep -Seconds 1" & vbCrLf & _
              "Stop-Process -Name ""Loading"" -Force" & vbCrLf & _
              "Stop-Process -Name ""Loading2"" -Force" & vbCrLf & _
              "Start-Sleep -Seconds 1" & vbCrLf & _
              "Stop-Process -Name ""Loading2"" -Force"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile(scriptPath, True)
objFile.Write fileContent
objFile.Close

' Завершаем процессы с именем "Loading.exe"
Set colProcesses = GetObject("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'Loading.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next

Set colProcesses = GetObject("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'Loading2.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next