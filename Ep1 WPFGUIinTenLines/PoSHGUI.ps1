<#
.NOTES
   Author      : Jim Moyle @jimmoyle
   GitHub      : https://github.com/JimMoyle/GUIDemo

    Version 0.0.1

    note (tilde's fork)
     may 2020
     that twitter module doesn't exist and I couldn't import a different one as I only get an error message
     so I'm going to try and do something else with this example
     
#>

#Add in the frameworks so that we can create the WPF GUI
Add-Type -AssemblyName presentationframework, presentationcore



#Create empty hashtable into which we will place the GUI objects
$wpf = @{ }


#Grab the content of the Visual Studio xaml file as a string
$inputXML = Get-Content -Path "S:\repos\GUIDemo\Ep1 WPFGUIinTenLines\WPFGUIinTenLines\MainWindow.xaml"

Clear-Host
$inputXML

Clear-Host
$firstItem = $inputXML | select-object -first 1
$firstItem.gettype().Fullname


#clean up xml there is syntax which Visual Studio 2015 creates which PoSH can't understand
$inputXMLClean = $inputXML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace 'x:Class=".*?"','' -replace 'd:DesignHeight="\d*?"','' -replace 'd:DesignWidth="\d*?"',''

Clear-Host
$inputXMLClean


#change string variable into xml
[xml]$xaml = $inputXMLClean

Clear-Host
$xaml.GetType().Fullname


#read xml data into xaml node reader object
$reader = New-Object System.Xml.XmlNodeReader $xaml

#create System.Windows.Window object
$tempform = [Windows.Markup.XamlReader]::Load($reader)
$tempform.GetType().Fullname

#select each named node using an Xpath expression.
$namedNodes = $xaml.SelectNodes("//*[@*[contains(translate(name(.),'n','N'),'Name')]]")


#add all the named nodes as members to the $wpf variable, this also adds in the correct type for the objects.
$namedNodes | ForEach-Object {

	$wpf.Add($_.Name, $tempform.FindName($_.Name))

}


#show what's inside $wpf
clear-Host
$wpf

Clear-Host
$wpf.YouTubeButton.GetType().Fullname

Clear-Host
$wpf.YouTubeButton

Clear-Host
$wpf.YouTubeButton.Content

Clear-Host
$buttonEvents = $wpf.YouTubeButton | Get-Member | Where-Object {$_.MemberType -eq 'Event'}
$buttonEvents.count


$wpf.YouTubeWindow.ShowDialog() | Out-Null