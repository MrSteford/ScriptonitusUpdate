<#
.SYNOPSIS

PSApppDeployToolkit - This script performs the installation or uninstallation of an application(s).

.DESCRIPTION

- The script is provided as a template to perform an install or uninstall of an application(s).
- The script either performs an "Install" deployment type or an "Uninstall" deployment type.
- The install deployment type is broken down into 3 main sections/phases: Pre-Install, Install, and Post-Install.

The script dot-sources the AppDeployToolkitMain.ps1 script which contains the logic and functions required to install or uninstall an application.

PSApppDeployToolkit is licensed under the GNU LGPLv3 License - (C) 2023 PSAppDeployToolkit Team (Sean Lillis, Dan Cunningham and Muhammad Mashwani).

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the
Free Software Foundation, either version 3 of the License, or any later version. This program is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
for more details. You should have received a copy of the GNU Lesser General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.

.PARAMETER DeploymentType

The type of deployment to perform. Default is: Install.

.PARAMETER DeployMode

Specifies whether the installation should be run in Interactive, Silent, or NonInteractive mode. Default is: Interactive. Options: Interactive = Shows dialogs, Silent = No dialogs, NonInteractive = Very silent, i.e. no blocking apps. NonInteractive mode is automatically set if it is detected that the process is not user interactive.

.PARAMETER AllowRebootPassThru

Allows the 3010 return code (requires restart) to be passed back to the parent process (e.g. SCCM) if detected from an installation. If 3010 is passed back to SCCM, a reboot prompt will be triggered.

.PARAMETER TerminalServerMode

Changes to "user install mode" and back to "user execute mode" for installing/uninstalling applications for Remote Desktop Session Hosts/Citrix servers.

.PARAMETER DisableLogging

Disables logging to file for the script. Default is: $false.

.EXAMPLE

powershell.exe -Command "& { & '.\Deploy-Application.ps1' -DeployMode 'Silent'; Exit $LastExitCode }"

.EXAMPLE

powershell.exe -Command "& { & '.\Deploy-Application.ps1' -AllowRebootPassThru; Exit $LastExitCode }"

.EXAMPLE

powershell.exe -Command "& { & '.\Deploy-Application.ps1' -DeploymentType 'Uninstall'; Exit $LastExitCode }"

.EXAMPLE

Deploy-Application.exe -DeploymentType "Install" -DeployMode "Silent"

.INPUTS

None

You cannot pipe objects to this script.

.OUTPUTS

None

This script does not generate any output.

.NOTES

Toolkit Exit Code Ranges:
- 60000 - 68999: Reserved for built-in exit codes in Deploy-Application.ps1, Deploy-Application.exe, and AppDeployToolkitMain.ps1
- 69000 - 69999: Recommended for user customized exit codes in Deploy-Application.ps1
- 70000 - 79999: Recommended for user customized exit codes in AppDeployToolkitExtensions.ps1

.LINK

https://psappdeploytoolkit.com
#>


[CmdletBinding()]
Param (
    [Parameter(Mandatory = $false)]
    [ValidateSet('Install', 'Uninstall', 'Repair')]
    [String]$DeploymentType = 'Install',
    [Parameter(Mandatory = $false)]
    [ValidateSet('Interactive', 'Silent', 'NonInteractive')]
    [String]$DeployMode = 'Interactive',
    [Parameter(Mandatory = $false)]
    [switch]$AllowRebootPassThru = $false,
    [Parameter(Mandatory = $false)]
    [switch]$TerminalServerMode = $false,
    [Parameter(Mandatory = $false)]
    [switch]$DisableLogging = $false
)

Try {
    ## Set the script execution policy for this process
    Try {
        Set-ExecutionPolicy -ExecutionPolicy 'ByPass' -Scope 'Process' -Force -ErrorAction 'Stop'
    }
    Catch {
    }

    ##*===============================================
    ##* VARIABLE DECLARATION
    ##*===============================================
    ## Variables: Application
    [String]$appID = 'WXAP0328'
    [String]$appVendor = 'Zscaler'
    [String]$appName = 'Zscaler'
    [String]$appVersion = '4.3.0.151'
    [String]$appArch = 'x64'
    [String]$appLang = 'EN'
    [String]$appRevision = 'R1'
    [String]$appvarient = 'GBL'
    [String]$appAZEditVersion = '1.0'
    [String]$appScriptVersion = '1.0.0'
    [String]$appScriptDate = '26/12/2023'
    [String]$appScriptAuthor = 'Deepika D'
    [String]$appInstallDate = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
    ##*===============================================
    ## Variables: Install Titles (Only set here to override defaults set by the toolkit)
     [String]$PackageName = $appID + "-" + $appVendor + "-" + $appName + "-" + $appVersion + "-" + $appLang + "-" + $appvarient + "-" + $appRevision
    [String]$installName = $PackageName
    [String]$installTitle = 'Zscaler 4.3.0.151'

    ##* Do not modify section below
    #region DoNotModify

    ## Variables: Exit Code
    [Int32]$mainExitCode = 0

    ## Variables: Script
    [String]$deployAppScriptFriendlyName = 'Deploy Application'
    [Version]$deployAppScriptVersion = [Version]'3.9.3'
    [String]$deployAppScriptDate = '02/05/2023'
    [Hashtable]$deployAppScriptParameters = $PsBoundParameters

    ## Variables: Environment
    If (Test-Path -LiteralPath 'variable:HostInvocation') {
        $InvocationInfo = $HostInvocation
    }
    Else {
        $InvocationInfo = $MyInvocation
    }
    [String]$scriptDirectory = Split-Path -Path $InvocationInfo.MyCommand.Definition -Parent

    ## Dot source the required App Deploy Toolkit Functions
    Try {
        [String]$moduleAppDeployToolkitMain = "$scriptDirectory\AppDeployToolkit\AppDeployToolkitMain.ps1"
        If (-not (Test-Path -LiteralPath $moduleAppDeployToolkitMain -PathType 'Leaf')) {
            Throw "Module does not exist at the specified location [$moduleAppDeployToolkitMain]."
        }
        If ($DisableLogging) {
            . $moduleAppDeployToolkitMain -DisableLogging
        }
        Else {
            . $moduleAppDeployToolkitMain
        }
    }
    Catch {
        If ($mainExitCode -eq 0) {
            [Int32]$mainExitCode = 60008
        }
        Write-Error -Message "Module [$moduleAppDeployToolkitMain] failed to load: `n$($_.Exception.Message)`n `n$($_.InvocationInfo.PositionMessage)" -ErrorAction 'Continue'
        ## Exit the script, returning the exit code to SCCM
        If (Test-Path -LiteralPath 'variable:HostInvocation') {
            $script:ExitCode = $mainExitCode; Exit
        }
        Else {
            Exit $mainExitCode
        }
    }

    ##Custome registry Variable:
    If($appArch -eq 'x64')
    {
        [String]$AZBrandingreg = "HKLM:\SOFTWARE\AstraZeneca\$PackageName"
    }
    Else
    {
        [String]$AZBrandingreg = "HKLM:\SOFTWARE\WOW6432Node\AstraZeneca\$PackageName"
    }

    ##Intune Source directory:
    [String]$cache = "${env:ProgramFiles(x86)}\AstraZeneca\Zscaler_4.3.0.151"
	[String]$Intunecache = "${env:ProgramFiles(x86)}\AstraZeneca\IntuneCache\$PackageName"

    ##Activesetup:
    [bool]$ActiveSetup= $False                   #<--- If Activesetup is necessary, set to $True and edit Userscript.ps1 in SupprotFiles
    [String]$ActiveSetupDir= "${env:ProgramFiles(x86)}\AstraZeneca\Scripts\$PackageName"
    [String]$ActiveSetupScript = "$ActiveSetupDir\UserPart.ps1" 

    
    ##Processes to close during Installation & uninstalltion.
    [String]$ProcessToClose = ''  #<--- List the Process without .exe 


    ##Reboot Declaration:
    [String]$appInstallReboot='False'
    [String]$appuninstallReboot ='False'

    ##MSI-Setup Declaration:
    [String]$MSIFile = "$Intunecache\Zscaler-windows-4.3.0.151-installer-x64.msi"              #<--- MSI file name
    [String]$TransformsFile = "$Intunecache\Zscaler-4.3.0.151-EN-GBL-R1.Mst"                                                                          #<--- Transforms file name
    [String]$MSPFile = ''                  #<--- MSP file name
    [String]$MSIParam = "/quiet /norestart"              #<--- MSI Parameters

    [String]$GUID = '{369C3598-4FDF-443B-A2BC-505E10E15CB3}'	#<--- MSI file name
    [String]$GUIDold1 = '{50B1AE2F-8CC9-4B74-9FE9-2E401B6931D0}'
    [String]$GUIDold2 = '{CA128AD3-FFFF-4B24-ACF2-E7D024C50D0E}'
    [String]$GUIDold3 = '{CEE08452-D0CE-4E50-A4DE-195A6D8A5B28}'
    [String]$GUIDold4 = '{8001155C-056B-4059-873A-2E2DA902F7F7}'
    [String]$GUIDold5 = '{19C0A3C8-EA79-4A3B-BF9B-4E7C8CA62998}'
	[String]$old1 = '61994-Zscaler-4.1-EN-GBL-R1'
	[String]$old2 = '61540-Zscaler-3.6-EN-GBL-R1'
	[String]$old3 = '61174-Zscaler-3.1.0.96-EN-GBL-R1'
	[String]$old4 = '60887-Zscaler-2.1.0.210-EN-GBL-R1'
	[String]$old5 = '61620-Zscaler-3.7-EN-GBL-R1'


    ##EXE-Setup Declaration:
    [String]$EXEFile = ''               #<--- EXE file name
    [String]$EXEInstallParam = ''       #<--- EXE file name

    [String]$EXEUninstFolder = ''       #<--- EXE file name
    [String]$EXEUninstFile = ''         #<--- EXE file name
    [String]$EXEUninstParam = ''        #<--- EXE file name

    ##Creating cache Folder:               #<--- Commmentout if this package is using in AZSS
    If(!(Test-Path -path $cache -PathType any))
    {
        New-Folder -Path $cache
        Copy-File -Path "$scriptDirectory\*.*" -Destination $cache -Recurse
		Copy-Item -Path "$scriptDirectory\AppDeployToolkit" -Destination $cache -Recurse
		Copy-Item -Path "$scriptDirectory\Files" -Destination $cache -Recurse
		
    }
	
	
	    
    
    #endregion
    ##* Do not modify section above
    ##*===============================================
    ##* END VARIABLE DECLARATION
    ##*===============================================

    If ($deploymentType -ine 'Uninstall' -and $deploymentType -ine 'Repair') {
        ##*===============================================
        ##* PRE-INSTALLATION
        ##*===============================================
        [String]$installPhase = 'Pre-Installation'

        ## Show Welcome Message, close Internet Explorer if required, allow up to 3 deferrals, verify there is enough disk space to complete the install, and persist the prompt
        <# Show-InstallationWelcome -CloseApps 'pycharm64' -AllowDeferCloseApps -CheckDiskSpace -PersistPrompt #> 


        $Version = Get-RegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\Zscaler Inc.\Zscaler' -Value 'Version'
        
        IF($Version -ge "4.3.0.151")
        {
            [Int32]$mainExitCode = 99
            Write-log -message "Zscaler 4.3.0.151 is already installed on this machine. Return Code:$mainExitCode " 
            Exit-Script -ExitCode $mainExitCode
        }
        else
        {
            Write-log -message " Checking if older version of software is installed and uninstalling it.."
        }

        ## <Perform Pre-Installation tasks here>
        $Version = Get-InstalledApplication -ProductCode $GUIDold1
        IF(($Version))
        {
            ## <Perform Installation tasks here>
            Write-log -message "Uninstallation of 61994-Zscaler-4.1-EN-GBL-R1 started..."
            Execute-MSI -Action 'Uninstall' -Path $GUIDold1 -Parameter $MSIParam -private:$old1
        }
		
		
        $Version = Get-InstalledApplication -ProductCode $GUIDold2
        IF(($Version))
        {
            ## <Perform Installation tasks here>
            Write-log -message "Uninstallation of 61540-Zscaler-3.6-EN-GBL-R1 started..."
            Execute-MSI -Action 'Uninstall' -Path $GUIDold2 -Parameter $MSIParam -private:$old2
        }
		
		$Version = Get-InstalledApplication -ProductCode $GUIDold3
        IF(($Version))
        {
            ## <Perform Installation tasks here>
            Write-log -message "Uninstallation of 61174-Zscaler-3.1.0.96-EN-GBL-R1 started..."
            Execute-MSI -Action 'Uninstall' -Path $GUIDold3 -Parameter $MSIParam -private:$old3
        }
		
		
		$Version = Get-InstalledApplication -ProductCode $GUIDold4
        IF(($Version))
        {
            ## <Perform Installation tasks here>
            Write-log -message "Uninstallation of 60887-Zscaler-2.1.0.210-EN-GBL-R1 started..."
            Execute-MSI -Action 'Uninstall' -Path $GUIDold4 -Parameter $MSIParam -private:$old4
        }
		
		$Version = Get-InstalledApplication -ProductCode $GUIDold5
        IF(($Version))
        {
            ## <Perform Installation tasks here>
            Write-log -message "Uninstallation of 61620-Zscaler-3.7-EN-GBL-R1 started..."
            Execute-MSI -Action 'Uninstall' -Path $GUIDold5 -Parameter $MSIParam -private:$old5
        }
		

        ##*===============================================
        ##* INSTALLATION
        ##*===============================================
        [String]$installPhase = 'Installation'
        
        ##Intune copy:
        New-Folder -Path $Intunecache
        Copy-File -Path "$dirFiles\*" -Destination $Intunecache -Recurse

        $Version = Get-RegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\Zscaler Inc.\Zscaler' -Value 'Version'
        
        IF($Version -ge "4.3.0.151")
        {
            [Int32]$mainExitCode = 99
            Write-log -message "Zscaler 4.3.0.151 is already installed on this machine. Return Code:$mainExitCode " 
            Exit-Script -ExitCode $mainExitCode
        }
        else
        {
            Write-log -message " Installation of the application $PackageName started..."
            Execute-MSI -Action 'Install' -Path $MSIFile -Transform $TransformsFile -Parameters $MSIParam -private:$PackageName
        }

        ##*===============================================
        ##* POST-INSTALLATION
        ##*===============================================
        [String]$installPhase = 'Post-Installation'

        ## <Perform Post-Installation tasks here>
		
		<# Set-RegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Zscaler' -Name 'NoModify' -Type 'DWord' -Value '1' #>
		
		Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Zscaler" -Name "NoModify" -Type 'DWord' -Value "1"

		Set-RegistryKey -Key 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Zscaler' -Name 'NoRemove' -Type 'DWord' -Value '1'
		
		Remove-Item -Path "${env:ProgramData}\Microsoft\Windows\Start Menu\Programs\Zscaler\Uninstall Zscaler.lnk" -Force

        ##Activesetup:
        <# IF($ActiveSetup)
        {
            If(!(Test-path $ActiveSetupDir)){ New-Folder -Path $ActiveSetupDir }
            Copy-File -path "$dirSupportFiles\*" -Destination $ActiveSetupDir -Recurse

            ##Set ActiveSetup
            Write-log -message "ActiveSetup created..."
            Set-ActiveSetup -StubExePath "$ActiveSetupScript" -Description 'PycharmCommunityEdition User Config' -Key $PackageName -Locale 'en'
    
        }
	 #>
	

        ##Delete Zip file
        #IF($source){ Remove-Folder -path $Source }


        ##Reboot Prompt:
        IF($appInstallReboot -eq 'True')
        { 
            [int32]$mainExitCode = 3010
            Show-InstallationRestartPrompt -NoCountdown 
        }

    }
    ElseIf ($deploymentType -ieq 'Uninstall') {
        ##*===============================================
        ##* PRE-UNINSTALLATION
        ##*===============================================
        [String]$installPhase = 'Pre-Uninstallation'

        ## Show Welcome Message, close Internet Explorer with a 60 second countdown before automatically closing
        <# Show-UninstallationWelcome -CloseApps 'pycharm64' -AllowDeferCloseApps -CheckDiskSpace -PersistPrompt #>  

        
        ## <Perform Pre-Uninstallation tasks here>


        ##*===============================================
        ##* UNINSTALLATION
        ##*===============================================
        [String]$installPhase = 'Uninstallation'

       
        ## <Perform Uninstallation tasks here>
        $Version = Get-InstalledApplication -ProductCode $GUID

        IF($Version)
        {
            Write-log -message "Zscaler 4.3.0.151 is Installed, proceed to uninstall..."
            Execute-MSI -Action 'Uninstall' -Path $GUID -Parameter $MSIParam -private:'WXAP0328-Zscaler-4.3.0.151-EN-GBL-R1'
			Start-Sleep -Seconds 90
            write-log -message "Zscaler 4.3.0.151 uninstallation completed successfully."
        }
        Else
        {
            [Int32]$mainExitCode = 99
            Write-log -message "Zscaler 4.3.0.151 is NOT installed on this machine. Return Code:$mainExitCode " 
            Exit-Script -ExitCode $mainExitCode 
        }

        ##*===============================================
        ##* POST-UNINSTALLATION
        ##*===============================================
        [String]$installPhase = 'Post-Uninstallation'

        ## <Perform Post-Uninstallation tasks here>
        
        ##removing the Activesetup directory:
        <# Remove-Folder -Path $ActiveSetupDir #>
        Remove-Folder -Path $Intunecache


        ##Remove the Branding registry:
        #Remove-RegistryKey -key $AZBrandingreg

        ##Reboot Prompt:
        IF($appUninstallReboot -eq 'True')
        { 
            [int32]$mainExitCode = 3010
            Show-UninstallationRestartPrompt -NoCountdown 
        }


    }
    ElseIf ($deploymentType -ieq 'Repair') {
        ##*===============================================
        ##* PRE-REPAIR
        ##*===============================================
        [String]$installPhase = 'Pre-Repair'

        ## Show Welcome Message, close Internet Explorer with a 60 second countdown before automatically closing
        Show-InstallationWelcome -CloseApps 'iexplore' -CloseAppsCountdown 60

        ## Show Progress Message (with the default message)
        Show-InstallationProgress

        ## <Perform Pre-Repair tasks here>

        ##*===============================================
        ##* REPAIR
        ##*===============================================
        [String]$installPhase = 'Repair'

        ## Handle Zero-Config MSI Repairs
        If ($useDefaultMsi) {
            [Hashtable]$ExecuteDefaultMSISplat = @{ Action = 'Repair'; Path = $defaultMsiFile; }; If ($defaultMstFile) {
                $ExecuteDefaultMSISplat.Add('Transform', $defaultMstFile)
            }
            Execute-MSI @ExecuteDefaultMSISplat
        }
        ## <Perform Repair tasks here>

        ##*===============================================
        ##* POST-REPAIR
        ##*===============================================
        [String]$installPhase = 'Post-Repair'

        ## <Perform Post-Repair tasks here>


    }
    ##*===============================================
    ##* END SCRIPT BODY
    ##*===============================================

    ## Call the Exit-Script function to perform final cleanup operations
    Exit-Script -ExitCode $mainExitCode
}
Catch {
    [Int32]$mainExitCode = 60001
    [String]$mainErrorMessage = "$(Resolve-Error)"
    Write-Log -Message $mainErrorMessage -Severity 3 -Source $deployAppScriptFriendlyName
    Show-DialogBox -Text $mainErrorMessage -Icon 'Stop'
    Exit-Script -ExitCode $mainExitCode
}
