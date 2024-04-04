Add-Type -AssemblyName PresentationFramework

function Get-Temperature {
    $t = Get-WmiObject MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"
    $returntemp = @()

    foreach ($temp in $t.CurrentTemperature) {
        $currentTempKelvin = $temp / 10
        $currentTempCelsius = $currentTempKelvin - 273.15
        $returntemp += $currentTempCelsius
    }

    return $returntemp[0]
}

$window = New-Object System.Windows.Window
$window.Title = "CPU Temperature"
$window.Width = 400
$window.Height = 170
$window.WindowStyle = [System.Windows.WindowStyle]::None
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

$textBlockTitle = New-Object System.Windows.Controls.TextBlock
$textBlockTitle.Text = "Processor Temperature"
$textBlockTitle.FontSize = 20
$textBlockTitle.TextAlignment = [System.Windows.TextAlignment]::Center

$temperature = Get-Temperature
$temperatureString = $temperature.ToString() + " C"

$textBlock = New-Object System.Windows.Controls.TextBlock
$textBlock.Text = $temperatureString
$textBlock.FontSize = 60
$textBlock.FontWeight = [System.Windows.FontWeights]::Bold
$textBlock.TextAlignment = [System.Windows.TextAlignment]::Center

$button = New-Object System.Windows.Controls.Button
$button.Content = "Close"
$button.FontSize = 20
$button.Width = 100
$button.Height = 40
$button.Add_Click({
    $window.Close()
})

$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Children.Add($textBlockTitle)
$stackPanel.Children.Add($textBlock)
$stackPanel.Children.Add($button)

$window.Content = $stackPanel

if ($temperature -lt 65) {
    $window.Background = [System.Windows.Media.Brushes]::Green
} elseif ($temperature -ge 65 -and $temperature -lt 75) {
    $window.Background = [System.Windows.Media.Brushes]::Orange
} else {
    $window.Background = [System.Windows.Media.Brushes]::Red
}

$closeTimer = New-Object System.Windows.Threading.DispatcherTimer
$closeTimer.Interval = [TimeSpan]::FromSeconds(7)
$closeTimer.Add_Tick({
    $window.Close()
})
$closeTimer.Start()

$window.ShowDialog() | Out-Null

# battery-report

$htmlFile = "C:\TempProfile\OS1\battery-report.html"
$designCapacity = Select-String -Path $htmlFile -Pattern 'DESIGN CAPACITY.*?(\d+)' | ForEach-Object { $_.Matches.Groups[1].Value }
$fullChargeCapacity = Select-String -Path $htmlFile -Pattern 'FULL CHARGE CAPACITY.*?(\d+)' | ForEach-Object { $_.Matches.Groups[1].Value }

$designCapacityWithDetails = $designCapacity + " " + (Select-String -Path $htmlFile -Pattern 'DESIGN CAPACITY.*?(\d+ \w+)' | ForEach-Object { $_.Matches.Groups[1].Value })
$fullChargeCapacityWithDetails = $fullChargeCapacity + " " + (Select-String -Path $htmlFile -Pattern 'FULL CHARGE CAPACITY.*?(\d+ \w+)' | ForEach-Object { $_.Matches.Groups[1].Value })

$designCapacityNumber = [int]($designCapacity -split ' ')[0]
$fullChargeCapacityNumber = [int]($fullChargeCapacity -split ' ')[0]

$percentage = [Math]::Round(($fullChargeCapacityNumber / $designCapacityNumber) * 100, 2)

Add-Type -AssemblyName PresentationFramework

$window = New-Object Windows.Window
$window.Width = 1000
$window.Height = 260
$window.WindowStyle = 'ToolWindow'
$window.Title = "Battery Report"

if ($percentage -ge 80) {
    $window.Background = 'Green'
    $message = "Design Capacity: $designCapacityWithDetails`nFull Charge Capacity: $fullChargeCapacityWithDetails`nFull Charge Capacity is $percentage% of the Design Capacity."
} elseif ($percentage -ge 70) {
    $window.Background = 'Yellow'
    $message = "Design Capacity: $designCapacityWithDetails`nFull Charge Capacity: $fullChargeCapacityWithDetails`nFull Charge Capacity is $percentage% of the Design Capacity."
} else {
    $window.Background = 'Red'
    $message = "Design Capacity: $designCapacityWithDetails`nFull Charge Capacity: $fullChargeCapacityWithDetails`nFull Charge Capacity is $percentage% of the Design Capacity."
}

$textBlock = New-Object Windows.Controls.TextBlock
$textBlock.Text = $message
$textBlock.FontWeight = 'Bold'
$textBlock.FontSize = 32
$textBlock.TextWrapping = 'Wrap'
$textBlock.TextAlignment = 'Center'

$closeButton = New-Object Windows.Controls.Button
$closeButton.Content = "Закрыть"
$closeButton.Width = 200
$closeButton.Height = 50
$closeButton.HorizontalAlignment = 'Center'
$closeButton.VerticalAlignment = 'Bottom'
$closeButton.Margin = '0,20,0,0'
$closeButton.FontSize = 28
$closeButton.FontWeight = 'Bold'

$closeButton.Add_Click({
    $window.Close()
})

$stackPanel = New-Object Windows.Controls.StackPanel
$stackPanel.Children.Add($textBlock)
$stackPanel.Children.Add($closeButton)

$window.Content = $stackPanel
$window.ShowDialog()

# CD
if (Test-Path "C:\TempProfile\OS1\APP\CD" -PathType Container) {
    $CrystalDiskInfoPath = "C:\TempProfile\OS1\Build_Script\CD\DiskInfo64.exe"
    Start-Process $CrystalDiskInfoPath -ArgumentList "/CopyExit" -Wait

    Add-Type -AssemblyName System.Windows.Forms

    $fileContent = Get-Content -Path "C:\TempProfile\OS1\Build_Script\CD\DiskInfo.txt"
    $healthStatus = $fileContent | Where-Object {$_ -like "   Health Status :*"} | ForEach-Object {$_ -replace "[^0-9]", ""}
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Health Status Number"
    $form.Size = New-Object System.Drawing.Size(700,150)
    $form.StartPosition = "CenterScreen"
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Health Disk Status : " + $healthStatus + "%"
    $label.AutoSize = $false
    $label.Font = New-Object System.Drawing.Font("Arial", 24, [System.Drawing.FontStyle]::Bold)
    $label.TextAlign = "MiddleCenter"
    $label.Size = New-Object System.Drawing.Size(700,100)
    $label.Location = New-Object System.Drawing.Point(0, 0)

    if ($healthStatus -ge 90) {
        $form.BackColor = [System.Drawing.Color]::Green
    } elseif ($healthStatus -ge 80) {
        $form.BackColor = [System.Drawing.Color]::Yellow
    } else {
        $form.BackColor = [System.Drawing.Color]::Red
    }

    $form.Controls.Add($label)
    $form.ShowDialog()

    Remove-Item "C:\Tempus\1\CD\DiskInfo.txt" -Force
    Remove-Item "C:\Tempus\1\CD\Smart" -Recurse -Force
}

$computerSystem = Get-WmiObject -Class Win32_ComputerSystem -Property Manufacturer, Model

function LenovoStart {
    Start-Process -FilePath "C:\TempProfile\OS1\Dr.exe" -ArgumentList "/VERYSILENT", "/NORESTART" -NoNewWindow 
}

if ($computerSystem.Manufacturer -eq "Lenovo") {
    LenovoStart
    $processName = "setup"
    $timeout = 10
    $interval = 1
    $elapsedTime = 0
    
    while ($elapsedTime -lt $timeout) {
        $process = Get-Process -Name $processName -ErrorAction SilentlyContinue
        if ($process) {
            Start-Sleep -Seconds 10
            Get-Process | Where-Object { $_.ProcessName -eq "setup" } | ForEach-Object {
                $_.Kill()
            }
            Get-Process | Where-Object { $_.ProcessName -eq "setapps" } | ForEach-Object {
                $_.Kill()
            }
            Get-Process | Where-Object { $_.ProcessName -eq "Dr" } | ForEach-Object {
                $_.Kill()
            }
            Get-Process | Where-Object { $_.ProcessName -eq "Dr.tmp" } | ForEach-Object {
                $_.Kill()
            }
        } else {
            Start-Sleep -Seconds $interval
            $elapsedTime += $interval
        }
    }

}
