powercfg /batteryreport /output "C:\TempProfile\OS1\battery-report.html"
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