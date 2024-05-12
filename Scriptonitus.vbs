' Version 10.3

Set objShell = CreateObject("WScript.Shell")
scriptPath = Replace(WScript.ScriptFullName, WScript.ScriptName, "")
exePath = scriptPath & "OS11\OS1\Animation\Loading.exe"

' Проверяем существование файла Loading.exe
If objShell.AppActivate(exePath) Then
    ' Если файл существует, запускаем его
    objShell.Run exePath
Else
    ' Если файл не найден, проверяем и запускаем GifUpdateSHA256.exe
    exePath = scriptPath & "OS11\OS1\Animation\GifUpdateSHA256.exe"
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

fileContent = "Set-Location ""C:\TempProfile\OS1\Animation""" & vbCrLf & _
              "$filePath2 = ""GifUpdateSHA256.exe""" & vbCrLf & _
              "$filePath = ""Gif_Main.exe""" & vbCrLf & _
              "if (Test-Path $filePath2) {" & vbCrLf & _
              "    Start-Process -FilePath ""GifMainSHA256.exe""" & vbCrLf & _
              "} else {" & vbCrLf & _
              "    if (Test-Path $filePath) {" & vbCrLf & _
              "        Start-Process -FilePath "$Gif_Main.exe"" & vbCrLf & _
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
              "            if (-not (Test-Path ""C:\TempProfile\OS1\Animation\GifUpdateSHA256.exe"")) {" & vbCrLf & _
              "                        $url = ""https://codeload.github.com/MrSteford/ScriptonitusUpdate/zip/refs/heads/Cinqu""" & vbCrLf & _
              "                        $scriptPath = $PSScriptRoot" & vbCrLf & _
              "                        $destination = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-Cinqu.zip""" & vbCrLf & _
              "                        Invoke-WebRequest -Uri $url -OutFile $destination" & vbCrLf & _
              "                        Expand-Archive -Path $destination -DestinationPath $scriptPath" & vbCrLf & _
              "                        $sourceFolder = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-Cinqu""" & vbCrLf & _
              "                        New-Item -Path ""C:\TempProfile\OS1\Build_Script\Animu"" -ItemType Directory -Force" & vbCrLf & _
              "                        $destinationFolder = ""C:\TempProfile\OS1\Build_Script\Animu""" & vbCrLf & _
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
              "$ntfsVolumes = Get-Disk -UniqueId ""*USB*"" | Get-Partition | Get-Volume | Where-Object { $_.FileSystem -eq ""NTFS"" -or $_.FileSystem -eq ""FAT32""}" & vbCrLf & _
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
              "            $destinationFolderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\APP\RP2""" & vbCrLf & _
              "            Copy-Item -Path $sourceFolderPath -Destination $destinationFolderPath -Recurse -Force" & vbCrLf & _
              "        }" & vbCrLf & _
              "        " & vbCrLf & _
              "        # Copy only files from the source folder to the additional folder path" & vbCrLf & _
              "        $files = Get-ChildItem -Path $sourceFolderPath -File" & vbCrLf & _
              "        foreach ($file in $files) {" & vbCrLf & _
              "            $destinationFile = Join-Path -Path $additionalFolderPath -ChildPath $file.Name" & vbCrLf & _
              "            Copy-Item -Path $file.FullName -Destination $destinationFile -Force" & vbCrLf & _
              "        }" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\Office""" & vbCrLf & _
              "    " & vbCrLf & _
              "    if (Test-Path $folderPath -PathType Container) {" & vbCrLf & _
              "        $destinationFilePath = Join-Path -Path $folderPath -ChildPath ""StartBAT.vbs""" & vbCrLf & _
              "        " & vbCrLf & _
              "        if (-not (Test-Path $destinationFilePath -PathType Leaf)) {" & vbCrLf & _
              "            $sourceFilePath = ""C:\TempProfile\OS1\Build_Script\StartBAT.vbs""" & vbCrLf & _
              "            Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -Force" & vbCrLf & _
              "        }" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "foreach ($volume in $ntfsVolumes) {" & vbCrLf & _
              "    $rootPath = $volume.DriveLetter + "":\""" & vbCrLf & _
              "    $folderPath = Join-Path -Path $rootPath -ChildPath ""GenScriptus_V10\OS11\OS1\Animation""" & vbCrLf & _
              "    if (Test-Path $folderPath -PathType Container) {" & vbCrLf & _
              "        $sourceFilePath1 = ""C:\TempProfile\OS1\Build_Script\Animu\GifMainSHA256.exe""" & vbCrLf & _
              "        $sourceFilePath2 = ""C:\TempProfile\OS1\Build_Script\Animu\GifUpdateSHA256.exe""" & vbCrLf & _
              "        $sourceFilePath3 = ""C:\TempProfile\OS1\Build_Script\Animu\CatGif.gif""" & vbCrLf & _
              "        $sourceFilePath4 = ""C:\TempProfile\OS1\Build_Script\Animu\GifEnot2.gif""" & vbCrLf & _
              "        $sourceFilePath5 = ""C:\TempProfile\OS1\Build_Script\Animu\Loading.gif""" & vbCrLf & _
              "        $sourceFilePath6 = ""C:\TempProfile\OS1\Build_Script\Animu\Update.gif""" & vbCrLf & _              
              "        if (Test-Path $sourceFilePath1) {" & vbCrLf & _
              "            Remove-Item -Path ""$folderPath\*"" -Force" & vbCrLf & _
              "            $destinationFilePath1 = Join-Path -Path $folderPath -ChildPath ""GifMainSHA256.exe""" & vbCrLf & _
              "            $destinationFilePath2 = Join-Path -Path $folderPath -ChildPath ""GifUpdateSHA256.exe""" & vbCrLf & _
              "            $destinationFilePath3 = Join-Path -Path $folderPath -ChildPath ""CatGif.gif""" & vbCrLf & _
              "            $destinationFilePath4 = Join-Path -Path $folderPath -ChildPath ""GifEnot2.gif""" & vbCrLf & _ 
              "            $destinationFilePath5 = Join-Path -Path $folderPath -ChildPath ""Loading.gif""" & vbCrLf & _
              "            $destinationFilePath6 = Join-Path -Path $folderPath -ChildPath ""Update.gif""" & vbCrLf & _                                                          
              "            Copy-Item -Path $sourceFilePath1 -Destination $destinationFilePath1 -Force" & vbCrLf & _
              "            Copy-Item -Path $sourceFilePath2 -Destination $destinationFilePath2 -Force" & vbCrLf & _
              "            Copy-Item -Path $sourceFilePath3 -Destination $destinationFilePath3 -Force" & vbCrLf & _
              "            Copy-Item -Path $sourceFilePath4 -Destination $destinationFilePath4 -Force" & vbCrLf & _
              "            Copy-Item -Path $sourceFilePath5 -Destination $destinationFilePath5 -Force" & vbCrLf & _
              "            Copy-Item -Path $sourceFilePath6 -Destination $destinationFilePath6 -Force" & vbCrLf & _                                                        
              "        }" & vbCrLf & _
              "    }" & vbCrLf & _
              "}" & vbCrLf & _
              "Stop-Process -Name ""Loading"" -Force" & vbCrLf & _
              "Start-Sleep -Seconds 1" & vbCrLf & _
              "Stop-Process -Name ""Loading"" -Force" & vbCrLf & _
              "Stop-Process -Name ""GifUpdateSHA256"" -Force" & vbCrLf & _
              "Start-Sleep -Seconds 1" & vbCrLf & _
              "Stop-Process -Name ""GifUpdateSHA256"" -Force"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile(scriptPath, True)
objFile.Write fileContent
objFile.Close

' Завершаем процессы с именем "Loading.exe"
Set colProcesses = GetObject("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'Loading.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next

Set colProcesses = GetObject("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'GifUpdateSHA256.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next