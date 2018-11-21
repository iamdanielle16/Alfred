Class HueBridge{

    [String]$HueBridgeIP
    [String]$Username

    ################
    # CONSTRUCTORS #
    ################

    HueBridge([String]$HueBridgeIP,[String]$Username){
        $this.HueBridgeIP = $HueBridgeIP
        $this.Username = $Username
    }

    ###########
    # METHODS #
    ###########

    # Returns the status of the specificied hue light, given the name
    [PsObject]GetHueStatus($DeviceName){
        try{
            $hueBridge  = "http://$($this.HueBridgeIP)/api"
            $result = Invoke-RestMethod -Method Get -Uri "$($hueBridge)/$($this.username)/lights"
            $Lights = ($Result.PSObject.Members | Where-Object {$_.MemberType -eq "NoteProperty"})

            if($DeviceName){
                ForEach($light in $lights){
                   if($light.value.name -eq $DeviceName){
                        return $Light
                   }
                }
                return "No light found matching $($this.DeviceName)"
            }else{
                return $Lights
            }
        }
        Catch {
            Write-Warning  "$($Error[0])"
            return "$($Error[0])"
        }
    }

    # Sets the status of the light
    [PSObject]SetHueStatus($DeviceName,$State){
         try{
            $hueBridge  = "http://$($this.HueBridgeIP)/api"
            $LightNumber = (Get-HueStatus -HueBridgeIP $this.HueBridgeIP -Username $this.username -DeviceName $DeviceName -Verbose).Name
            $body = @{"on"=$state} | ConvertTo-Json
            Write-Verbose "$($hueBridge)/$($this.username)/lights/$($lightnumber)/state"
            $result = Invoke-RestMethod -Method Put -Uri "$($hueBridge)/$($this.username)/lights/$($lightnumber)/state" -Body $body
            return $result
        }
        Catch {
            Write-Warning  "$($Error[0])"
            return "$($Error[0])"
        }
    }

    
}