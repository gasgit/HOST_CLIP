[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @"
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        Title="MainWindow" Height="250.937" Width="417.383" ResizeMode="NoResize" WindowStartupLocation="CenterScreen" WindowStyle="None" Background="White">
    <Grid HorizontalAlignment="Left" Width="407" Height="200" VerticalAlignment="Top">
        <Label Name="label" Content="Hostname" HorizontalAlignment="Left" Margin="10,56,0,0" VerticalAlignment="Top" Width="132"/>
        <Label Name="label1" Content="OS" HorizontalAlignment="Left" Margin="10,86,0,0" VerticalAlignment="Top" Width="132"/>
        <Label Name="label1_Copy" Content="Domain" HorizontalAlignment="Left" Margin="10,116,0,0" VerticalAlignment="Top" Width="132"/>
        <Label Name="label2" Content="PC Information" HorizontalAlignment="Left" Margin="10,12,0,0" VerticalAlignment="Top" Width="387" FontSize="14" FontWeight="Bold"/>
        <TextBox Name="textBox" HorizontalAlignment="Left" Height="23" Margin="142,60,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="252" BorderThickness="0" FontWeight="Bold"/>
        <TextBox Name="textBox1" HorizontalAlignment="Left" Height="23" Margin="142,90,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="252" BorderThickness="0" FontWeight="Bold"/>
        <TextBox Name="textBox2" HorizontalAlignment="Left" Height="23" Margin="142,120,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" Width="252" BorderThickness="0" FontWeight="Bold"/>
        <Button Name="buttonClip" Content="Copy Hostname" Margin="149,150,149,0" VerticalAlignment="Top"/>
        <Button Name="button" Content="Close" Margin="149,180,149,0" VerticalAlignment="Top"/>

    </Grid>
</Window>
"@

#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml) 
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader"; exit}

# XAML objects to ps
$xaml.SelectNodes("//*[@Name]") | ForEach-Object {Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

#Get system variables
$textBox.text = $env:COMPUTERNAME
$textBox1.text = gwmi win32_operatingsystem | % caption
#$textBox1.text = $env:PROCESSOR_ARCHITECTURE
$textBox2.text = $env:USERDOMAIN

#Copy to clipboard
$buttonClip.Add_Click({
        $textBox.text | clip
        Get-NetAdapater | clip
})

#Close form
$button.Add_Click({
    $form.Close()
})

#Show Form
$Form.ShowDialog() | out-null