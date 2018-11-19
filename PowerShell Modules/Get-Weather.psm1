Function Get-Weather { 
<#   
.SYNOPSIS   
   Display weather data for a specific country, state, city. 
.DESCRIPTION 
   Display weather data for a specific country, state, city. There is a possibility for this to fail if the web service being used is unavailable. 
.PARAMETER Country 
    Country of city to view weather  
.PARAMETER City 
    City to view weather of 
.PARAMETER State 
    State to view weather of          
.NOTES   
    Name: Get-Weather 
    Author: iamdanielle16
    DateCreated: 18Nov2018  

.EXAMPLE   
    Get-Weather -Country "United States" -City Austin -State Texas
        
Description 
------------ 
Retrieves the current weather information for Austin, Texas in the United States 
 
#>  
[cmdletbinding( 
    DefaultParameterSetName = 'Default', 
    ConfirmImpact = 'low' 
)] 
    Param( 
        [Parameter(  
            Position = 0, 
            Mandatory = $False,
            ParameterSetName = '')] 
            [string]$Country, 
        [Parameter( 
            Position = 1, 
            Mandatory = $False, 
            ParameterSetName = '')] 
            [string]$City, 
        [Parameter( 
            Position = 1, 
            Mandatory = $False, 
            ParameterSetName = '')] 
            [string]$State                         
        ) 
Begin { 
    Write-Verbose "Country: $Country, City $City, State $State"
    $URI = "https://query.yahooapis.com/v1/public/yql?q=select  * from weather.forecast where woeid in (select woeid from geo.places(1) where  text='{0}, {1}')&format=json&env=store://datatables.org/alltableswithkeys"  -f $Country, $City, $State  
   
    Try  {    
        Write-Verbose "Invoking yahoo request"
        $weather  = (Invoke-RestMethod  -Uri $URI).query.results.channel        
        $weatherobject  = [pscustomobject]@{
            Title = $weather.title
            LastUpdated = [datetime]"$(($weather.LastBuildDate | Select-String -pattern  "\w+,\s\d{1,2}\s\w+\s\d{4}\s\d{1,2}:\d{1,2}\s\w{2}").matches[0].value)"
            City =  $weather.Location.City
            State =  $State
            Country =  $weather.Location.Country
            WindChill =  $weather.Wind.Chill
            WindSpeed =  $weather.Wind.Speed
            Humidity = $weather.atmosphere.humidity
            Pressure = $weather.atmosphere.pressure
            Visibility = $weather.atmosphere.visibility
            Sunrise =  $weather.astronomy.Sunrise
            Sunset =  $weather.astronomy.Sunset
            CurrentTemperature = "{0}{1}F" -f $weather.Item.Condition.Temp,[char]176
            CurrentCondition =  $weather.Item.Condition.Text
            HighTemp =  "{0}{1}F" -f  $Weather.item.forecast[0].High,[char]176
            LowTemp =  "{0}{1}F" -f  $Weather.item.forecast[0].Low,[char]176
            Forecast = $weather.item.forecast
        }
        return  $weatherobject
    }

    Catch {
        Write-Warning  "$($Error[0])"
    }
} 
End { 
    Write-Verbose "End function" 
    }    
}