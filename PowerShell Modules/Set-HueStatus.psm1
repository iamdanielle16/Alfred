Function Set-HueStatus{
<#   
.SYNOPSIS   
   Sets the status of a device by device name
.DESCRIPTION 
   Sets the status of a device by device name and defined parameters
.PARAMETER HueBridgeIP
    IP address or DNS name of Hue Bridge
.PARAMETER Username 
    Supply authorized username for accessing hue bridge
.PARAMETER DeviceName 
    Name of the device    
.PARAMETER State 
   True of false to turn light on or off       
.NOTES   
    Name: Set-HueStatus 
    Author: iamdanielle16
    DateCreated: 19Nov2018  

.EXAMPLE   
    Set-HueStatus -HueBridgeIP "ip address" -Username "api token" -DeviceName "Lamp" -State $false

Description 
------------ 
Turns the Livign room side lamp off 
 
#>  
[cmdletbinding( 
    DefaultParameterSetName = 'Default', 
    ConfirmImpact = 'low' 
)] 
    Param( 
        [Parameter(  
            Position = 0, 
            Mandatory = $True,
            ParameterSetName = '')] 
            [string]$HueBridgeIP, 
        [Parameter( 
            Position = 1, 
            Mandatory = $True, 
            ParameterSetName = '')] 
            [string]$Username, 
        [Parameter( 
            Position = 1, 
            Mandatory = $False, 
            ParameterSetName = '')] 
            [string]$DeviceName,
         [Parameter( 
            Position = 1, 
            Mandatory = $True, 
            ParameterSetName = '')] 
            [boolean]$State                      
        ) 
Begin { 
    try{
        $hueBridge  = "http://$($HueBridgeIP)/api"
        $LightStatus = Get-HueStatus -HueBridgeIP $HueBridgeIP -Username $username -DeviceName $DeviceNme -Verbose
        $LightNumber = $LightStatus.name
        $body = @{"on"=$state} | ConvertTo-Json
        $result = Invoke-RestMethod -Method Put -Uri "$($hueBridge)/$($username)/lights/$($lightnumber)/state" -Body $body
        return $result
    }
    Catch {
        Write-Warning  "$($Error[0])"
    }
}
End { 
    Write-Verbose "End function" 
    }  
}