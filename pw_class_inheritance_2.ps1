cls

# Implementing Interface
# importing IFormattable imterface to format the result using ToString(-,-) , without that it was showing output in pstable format
# importing IEquatable to compare two objects.
# importing System.IComparable interface helps to use -lt, -le, -gt, and -ge
class Temprature: System.IFormattable,System.IComparable,System.IEquatable[Object] {

    [float] $Degree
    [TempratureScale] $Scale

    Temprature(){}

    Temprature([float] $Degree) {$this.Degree= $Degree}

    Temprature([TempratureScale] $Scale) {$this.Scale= $Scale}

    Temprature([float] $Degree, [TempratureScale] $Scale){
        $this.Degree= $Degree
        $this.Scale= $Scale
    }

    [float] ToKelvin(){
        switch($this.Scale){
            Celsius {return $this.Degree + 273.15}
            Fahrenheit {return ($this.Degree + 459.67) * 5/9}
        }
        return $this.Degree
    }

    [float] ToCelsius(){
        switch($this.Scale){
            Fahrenheit {return ($this.Degree -32) * 5/9}
            Kelvin {return $this.Degree - 273.15}
        }

        return $this.Degree
    }

    [float] ToFahrenheit(){
        switch($this.Scale){
        
            Celsius {return $this.Degree * 9/5 +32}
            Kelvin {return $this.Degree * 9/5 -459.67}
        }

        return $this.Degree
    }
<#
 above code gives error 
    - Don't display correctly as String
    - Can't be checked properly for equivalency.
    - Can't be compared.
#>


# Above can be fixed by implementing Interface
# (1. Don't display correctly as String) ====> can be fixed by Implementing IFormattable

   [string] ToString([string] $Format,[System.IFormatProvider] $FormatProvider){

   #If format is not specified, use the defined scale.
   Write-Verbose "==================================================" 

    if([string]::IsNullOrEmpty($Format)){
        
        $Format= switch($this.Scale){
            Celsius {'C'}
            Fahrenheit {'F'}
            Kelvin {'K'}
        }
    }
    #If format provider is not specified , use the current culture.
    if($null -eq $FormatProvider){
        
        $FormatProvider= [cultureinfo]::CurrentCulture
    }

    # Format the temprature
    switch($Format){
        
        'C' {
            return $this.ToCelsius().ToString('F2', $FormatProvider) +'°C'
        }
        'F'{
            return $this.ToFahrenheit().ToString('F2', $FormatProvider) + '°F'
        }

        'K' {
            return $this.ToKelvin().ToString('F2',$FormatProvider) + '°K'
         }
    }

    # If we get here, the format is invalid.
    throw [System.FormatException]::new("Unknown format: '$Format' . Valid Formats are 'C', 'F', 'K'")
}

    [string] ToString([string]$Format){
        return $this.ToString($Format, $null)
    }

    ## below Default ToString  will call [string] ToString([string] $Format,[System.IFormatProvider] $FormatProvider)
    [string] ToString(){
        return $this.ToString($null, $null)
    }

    # Compare two objects 
    [bool] Equals([Object]$Other){
    
        # If the other object is null, we can't compare it.
        if($null -eq $Other){
            return $false
        }

        #If Other object is not a temprature, we cannot compare it.
        $OtherTemprature=$Other -as [Temprature]
        if($null -eq $OtherTemprature){
            return $false

        }
        #compare the tempratures as Kelvin
        return $this.ToKelvin() -eq $OtherTemprature.ToKelvin()
    }

    [int] CompareTo([Object]$Other){
    
        # if other object is null, consider this instance "greater than"
        if($null -eq $Other){
            return 1
        }

        # if the other object is not a temprature , we cannot compare it.
        $OtherTemprature= $Other -as [Temprature]
        if($null -eq $OtherTemprature){
            throw [System.ArgumentException]::new(
                "Object must be of type 'Temprature' ."
            )
        }

        # Compare the temrature as Kelvin
        return $this.ToKelvin().CompareTo($OtherTemprature.ToKelvin())
    }
}

enum TempratureScale{
    Celsius       = 0
    Fahrenheit  = 1
    Kelvin         = 2
}


$Celsius=[Temprature]::new()
"The temperature is $Celsius"
$Fahrenheit=[Temprature]::new([TempratureScale]::Fahrenheit)
$Kelvin= [Temprature]::new(0,'Kelvin')

#$Celsius, $Fahrenheit, $Kelvin

"The tempratures are : $Celsius, $Fahrenheit, $Kelvin "

$Temp=[Temprature]::new()
$Temp.ToString()
$Temp.ToString('K')
$Temp.ToString('F',$null)
Write-Host "==================================================="
#Compare objects
$Celsius=[Temprature]::new()
$Fahrenheit=[Temprature]::new(32,'Fahrenheit')
$Kelvin=[Temprature]::new([TempratureScale]::Kelvin)
@"
Temperatures are: $Celsius, $Fahrenheit, $Kelvin
`$Celsius.Equals(`$Fahrenheit) = $($Celsius.Equals($Fahrenheit))
`$Celsius -eq `$Fahrenheit     = $($Celsius -eq $Fahrenheit)
`$Celsius -ne `$Kelvin         = $($Celsius -ne $Kelvin)
"@

Write-Host "==================================================="
#use -lt, -gt, -le with objects.
$Celsius    = [Temprature]::new()
$Fahrenheit = [Temprature]::new(32, 'Fahrenheit')
$Kelvin     = [Temprature]::new([TempratureScale]::Kelvin)

@"
Temperatures are: $Celsius, $Fahrenheit, $Kelvin
`$Celsius.Equals(`$Fahrenheit)    = $($Celsius.Equals($Fahrenheit))
`$Celsius.Equals(`$Kelvin)        = $($Celsius.Equals($Kelvin))
`$Celsius.CompareTo(`$Fahrenheit) = $($Celsius.CompareTo($Fahrenheit))
`$Celsius.CompareTo(`$Kelvin)     = $($Celsius.CompareTo($Kelvin))
`$Celsius -lt `$Fahrenheit        = $($Celsius -lt $Fahrenheit)
`$Celsius -le `$Fahrenheit        = $($Celsius -le $Fahrenheit)
`$Celsius -eq `$Fahrenheit        = $($Celsius -eq $Fahrenheit)
`$Celsius -gt `$Kelvin            = $($Celsius -gt $Kelvin)
"@


