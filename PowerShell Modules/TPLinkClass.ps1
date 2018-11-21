# Credit to https://github.com/EgoManiac/TPlink-PoSH/blob/master/TPlinkPlugControlNew.ps1 for encoding work

Class TPLinkClass{

    # Submit human readable command, return TPLink formatted command 
    [String]ConvertToTPLinkFormat([String]$Command){

          $CommandHashMap = @{ "SystemInfo"="{""system"":{""get_sysinfo"":null}}";
                "Reboot"="{""system"":{""reboot"":{""delay"":1}}}";
                "Reset"="{""system"":{""reset"":{""delay"":1}}}";
                "TurnOn"="{""system"":{""set_relay_state"":{""state"":1}}}";
                "TurnOff"="{""system"":{""set_relay_state"":{""state"":0}}}";}

          return $CommandHashMap[$Command]
    
    }        

    [System.Object[]]EncodeToTPLink($CommandJSON){
        $EncryptedString = @()
        $enc = [system.Text.Encoding]::UTF8

        $bytes = $enc.GetBytes($CommandJSON) 

        # Tplink uses a dummy first 4 bytes so we pad with 4 0's at the beginning
        for($i = 0; $i -lt 4;$i++){
            $EncryptedString += "0"
        }
        #The first encryption key for the bxor method is 171

        [byte]$key = 171
        
        # Loop through the byte array then use the next character byte value as the key
        for($i=0; $i -lt $bytes.count ; $i++)
        {
            $a = $key -bxor $bytes[$i]
            $key = $a
            $EncryptedString += "$($a)"
        
        }

       return $EncryptedString   #(Needs to be System.Object[])
    }

    SendTPLink([String]$Command,[IpAddress]$IPAddress,[Int]$Port){

        [int]$Port = 9999

         #Create an instance of the .Net TCP Client class
        $TCPClient = New-Object -TypeName System.Net.Sockets.TCPClient

        #Use the TCP client class to connect to the TP-Link plug
        $TCPClient.connect($IPAddress,$Port)

        #Return the network stream from the TCP client
        $Stream = $TCPClient.GetStream()

        #Convert the friendly command to the corresponding JSON command
        $JSON =  $this.ConvertToTPLinkFormat($Command)

        #Convert the JSON command to TPLink byte format
        $EncodedCommand = $this.EncodeToTPLink($JSON)

         #Write the command to the TCP Client stream twice. Unsure why twice.
        $Stream.write($EncodedCommand,0,$EncodedCommand.Length)
        $Stream.write($EncodedCommand,0,$EncodedCommand.Length)

        $Tcpclient.Dispose()
        $Tcpclient.Close()

    }
}