$ntfsVolumes = Get-Disk -UniqueId "*USB*" | Get-Partition | Get-Volume | Where-Object { $_.FileSystem -eq "NTFS" }

## Replacing the files on USB Flesh

foreach ($volume in $ntfsVolumes) {
    $rootPath = $volume.DriveLetter + ":\"
    $folderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10\OS11"
    
    if (Test-Path $folderPath -PathType Container) {
        $sourceFilePath = "C:\TempProfile\OS1\Build_Script\START.exe"
        $destinationFilePath = Join-Path -Path $folderPath -ChildPath "START.exe"
        
        Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -Force
    }
}

foreach ($volume in $ntfsVolumes) {
    $rootPath = $volume.DriveLetter + ":\"
    $folderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10"
    
    if (Test-Path $folderPath -PathType Container) {
        $sourceFilePath = "C:\TempProfile\OS1\Build_Script\Scriptonitus.vbs"
        $destinationFilePath = Join-Path -Path $folderPath -ChildPath "Scriptonitus.vbs"
        
        Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -Force
    }
}

foreach ($volume in $ntfsVolumes) {
    $rootPath = $volume.DriveLetter + ":\"
    $folderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10\OS11\OS1"
    
    if (Test-Path $folderPath -PathType Container) {
        $destinationFilePath = Join-Path -Path $folderPath -ChildPath "CheckSound.wav"
        
        if (-not (Test-Path $destinationFilePath -PathType Leaf)) {
            $sourceFilePath = "C:\TempProfile\OS1\Build_Script\CheckSound.wav"
            Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -Force
        }
    }
}

foreach ($volume in $ntfsVolumes) {
    $rootPath = $volume.DriveLetter + ":\"
    $folderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10\OS11\OS1\Build_Script"
    
    if (Test-Path $folderPath -PathType Container) {
        $destinationFilePath = Join-Path -Path $folderPath -ChildPath "Update.ps1"
        
        if (Test-Path $destinationFilePath -PathType Leaf) {
            Remove-Item -Path $destinationFilePath -Force
        }
    }
}

foreach ($volume in $ntfsVolumes) {
    $rootPath = $volume.DriveLetter + ":\"
    $folderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10"
    
    if (Test-Path $folderPath -PathType Container) {
        $destinationFilePath = Join-Path -Path $folderPath -ChildPath "Scriptonitus.bat"
        
        if (Test-Path $destinationFilePath -PathType Leaf) {
            Remove-Item -Path $destinationFilePath -Force
        }
    }
}

# foreach ($volume in $ntfsVolumes) {
#     $rootPath = $volume.DriveLetter + ":\"    
#     $folderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10\OS11\OS1\APP\"

#     $sourceFolderPath = "C:\TempProfile\OS1\Build_Script\S"

#     if (Test-Path $sourceFolderPath -PathType Container) {
#         $destinationFolderPath = Join-Path -Path $folderPath -ChildPath "S"
#         Copy-Item -Path $sourceFolderPath -Destination $destinationFolderPath -Recurse -Force
#     }
# }

foreach ($volume in $ntfsVolumes) {
    $rootPath = $volume.DriveLetter + ":\"
    $folderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10\OS11\OS1\APP\S"

    if (-not (Test-Path $folderPath)) {
        $sourceFolderPath = "C:\TempProfile\OS1\Build_Script\S"

        if (Test-Path $sourceFolderPath -PathType Container) {
            $destinationFolderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10\OS11\OS1\APP\S"
            Copy-Item -Path $sourceFolderPath -Destination $destinationFolderPath -Recurse -Force
        }
    }
}

foreach ($volume in $ntfsVolumes) {
    $rootPath = $volume.DriveLetter + ":\"
    $folderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10\OS11\OS1\APP\CD"

    if (-not (Test-Path $folderPath)) {
        $sourceFolderPath = "C:\TempProfile\OS1\Build_Script\CD"

        if (Test-Path $sourceFolderPath -PathType Container) {
            $destinationFolderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10\OS11\OS1\APP\CD"
            Copy-Item -Path $sourceFolderPath -Destination $destinationFolderPath -Recurse -Force
        }
    }
}

foreach ($volume in $ntfsVolumes) {
    $rootPath = $volume.DriveLetter + ":\"
    $folderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10\OS11\OS1\APP\S"

    $nestedFolderPath = Join-Path -Path $folderPath -ChildPath "S\S"

    if (Test-Path $nestedFolderPath -PathType Container) {
        Remove-Item $nestedFolderPath -Recurse -Force
        Write-Output "Folder S removed from path: $nestedFolderPath"
    }
}

foreach ($volume in $ntfsVolumes) {
    $rootPath = $volume.DriveLetter + ":\"
    $folderPath = Join-Path -Path $rootPath -ChildPath "GenScriptus_V10\OS11\OS1\Animation"
    
    if (Test-Path $folderPath -PathType Container) {
        $destinationFilePath = Join-Path -Path $folderPath -ChildPath "Loading.exe"
        
        if (-not (Test-Path $destinationFilePath -PathType Leaf)) {
            $sourceFilePath = "C:\TempProfile\OS1\Build_Script\Loading.exe"
            Copy-Item -Path $sourceFilePath -Destination $destinationFilePath -Force
        }
    }
}
