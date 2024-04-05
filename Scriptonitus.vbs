Set objShell = CreateObject("WScript.Shell")
scriptPath = Replace(WScript.ScriptFullName, WScript.ScriptName, "")
exePath = scriptPath & "OS11\OS1\Animation\Loading.exe"
objShell.Run exePath

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
fileContent = "$exePath = ""C:\TempProfile\OS1\Animation\Loading.exe""" & vbCrLf & _
              "if (Test-Path $exePath) {" & vbCrLf & _
              "Start-Process $exePath" & vbCrLf & _
              "}" & vbCrLf & _
              "$webRequest = [System.Net.WebRequest]::Create(""http://www.google.com"")" & vbCrLf & _
              "$asyncResult = $webRequest.BeginGetResponse($null, $null)" & vbCrLf & _
              "$waitHandle = $asyncResult.AsyncWaitHandle" & vbCrLf & _
              "if ($waitHandle.WaitOne(7000)) {" & vbCrLf & _
              "    try {" & vbCrLf & _
              "        $response = $webRequest.EndGetResponse($asyncResult)" & vbCrLf & _
              "        if ($response.StatusCode -eq ""OK"") {" & vbCrLf & _
              "            $url = ""https://codeload.github.com/MrSteford/ScriptonitusUpdate/zip/refs/heads/main""" & vbCrLf & _
              "            $scriptPath = $PSScriptRoot" & vbCrLf & _
              "            $destination = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-main.zip""" & vbCrLf & _
              "            Invoke-WebRequest -Uri $url -OutFile $destination" & vbCrLf & _
              "            Expand-Archive -Path $destination -DestinationPath $scriptPath" & vbCrLf & _
              "            $sourceFolder = Join-Path -Path $scriptPath -ChildPath ""ScriptonitusUpdate-main""" & vbCrLf & _
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
              "Get-Process | Where-Object { $_.ProcessName -eq ""Loading"" } | Stop-Process -Force"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile(scriptPath, True)
objFile.Write fileContent
objFile.Close

' Завершаем процессы с именем "Loading.exe"
Set colProcesses = GetObject("winmgmts:").ExecQuery("Select * from Win32_Process Where Name = 'Loading.exe'")
For Each objProcess in colProcesses
    objProcess.Terminate()
Next