Function Get-HueStatus{
<#   
.SYNOPSIS   
   Display status of devices connected to hue bridge 
.DESCRIPTION 
   Display status and information on all devices connected to hue bridge or specific named devices
.PARAMETER HueBridgeIP
    IP address or DNS name of Hue Bridge
.PARAMETER Username 
    Supply authorized username for accessing hue bridge
.PARAMETER DeviceName 
    Name of the device       
.NOTES   
    Name: Get-HueStatus 
    Author: iamdanielle16
    DateCreated: 19Nov2018  

.EXAMPLE   
    Get-HueStatue -HueBridgeIP "ipaddress" -Username "api token" 
        
Description 
------------ 
Retrieves the information for all devices connected to hue bridge or specificed named device
 
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
            [string]$DeviceName                         
        ) 
Begin { 
    try{
        $hueBridge  = "http://$($HueBridgeIP)/api"
        Write-Verbose $hueBridge
        $result = Invoke-RestMethod -Method Get -Uri "$($hueBridge)/$($username)/lights"
        $Lights = ($Result.PSObject.Members | Where-Object {$_.MemberType -eq "NoteProperty"})

        if($DeviceName){
            ForEach($light in $lights){
               if($light.value.name -eq $DeviceName){
                    return $Light
               }
            }
            return "No results"
        }else{
            return $Lights
        }
    }
    Catch {
        Write-Warning  "$($Error[0])"
    }
}
End { 
    Write-Verbose "End function" 
    }  
}