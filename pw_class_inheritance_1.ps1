#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
cls

# Inheriting and overriding from a base class

class PublishedWork{

    static [PublishedWork[]] $List =@()
    static [string[]]                $Artists=@()

    static [void] RegisterWork([PublishedWork]$Work){
        
        $wName = $Work.Name
        $wArtist= $Work.Artist

        if($Work -notin [PublishedWork]::List){
            
            Write-Verbose "Adding work '$wName' to works list"
            [PublishedWork]::List += $Work
        }else{
            
            Write-Verbose "Work '$wName' already registered."
        }

        if ($wArtist -notin [PublishedWork]::Artists){
            Write-Verbose "Adding artist '$wArtist' to artists list"
            [PublishedWork]::Artists +=$wArtist
        }else{
            Write-Verbose "Artist '$wArtist' already registered."
        }
    }

    static [void] ClearRegistry(){
        
        Write-Verbose "Clearing PublishedWork registry"
        [PublishedWork]::List =@()
        [PublishedWork]::Artists=@()
    }

    [string] $Name
    [string] $Artist
    [string] $Category

    [void] Init([string]$WorkType){
    
        if([string]::IsNullOrEmpty($this.Category)){
        
            
            $this.Category="${WorkType}s"
        }
    }

    PublishedWork(){
        $WorkType= $this.GetType().FullName
        $this.Init($WorkType)
        Write-Verbose "Defined a published work of type [$WorkType]"
    }

    PublishedWork([string]$Name,[string]$Artist){
        
        $WorkType = $this.GetType().FullName
        $this.Name  = $Name
        $this.Artist  = $Artist
        $this.Init($WorkType)

        Write-Verbose "Defined '$Name' by $Artist as a published work of type [$WorkType]"
    }

    PublishedWork([string]$Name, [string]$Artist,[string]$Category){
    
        $WorkType=$this.GetType().FullName
        $this.Name= $Name
        $this.Artist = $Artist
        $this.Init($WorkType)

        Write-Verbose "Defined '$Name' by $Artist ($Category) as a published work of type [$WorkType]"
    }

    [void] Register(){
        [PublishedWork]::RegisterWork($this)
    }

    [string] ToString(){
        return "$($this.Name) by $($this.Artist)"
    }

}

class Album : PublishedWork{

    [string[]] $Genres =@()
}

$VerbosePreference='Continue'

$Albums=@(
    [Album]@{
        Name="The Dark Side of the Moon"
        Artist="Pink Floyd"
        Genres="Progressive rock","Psychedelic rock"
    }
    [Album]@{
        Name="The Wall"
        Artist="Pink Floyd"
        Genres="Progressive rock","Art rock"
    }
    [Album]@{
        Name="36 Chambers"
        Artist="Wu-Tang Clan"
        Genres="Hip hop"
    }
)

$Albums | Format-Table

$Albums |ForEach-Object {[Album]::RegisterWork($_)}
$Albums |ForEach-Object {[PublishedWork]::RegisterWork($_)}

#Compare the base class and Derived class output

[pscustomobject]@{

    '[PublishedWork]::List' = [PublishedWork]::List -join ", `n"
    '[Album]::List'  = [Album]::List -join ", `n"

    '[PublishedWork]::Artists'= [PublishedWork]::Artists -join ", `n"
    '[Album]::Artists'= [Album]::Artists -join ", `n"

    'IsSame::List' = (
        [PublishedWork]::List.Count -eq [Album]::List.Count -and
        [PublishedWork]::List.ToString() -eq [Album]::List.ToString()
    )

    'IsSame::Artist'=(
        [PublishedWork]::Artists.Count -eq [Album]::Artists.Count -and
        [PublishedWork]::Artists.ToString() -eq [Album]::Artists.ToString()
    )
} |Format-List

class Illustration: PublishedWork{
    
    static [string[]] $Artists= @()
    static[void] RegisterIllustration([Illustration]$Work){
        
        $wArtist= $Work.Artist

        [PublishedWork]::RegisterWork($Work)

        if($wArtist -notin [Illustration]::Artists){
            
            Write-Verbose "Adding illustrator '$wArtist' to artists list'"
            [Illustration]::Artists += $wArtist

        }else{
            
            Write-Verbose "Illustrator '$wArtist' already registered."
        }
    }

    [string] $Category='Illustrations'
    [string] $Medium = 'Unknown'

    [string] ToString(){
        return "$($this.Name) by $($this.Artist) ($($this.Medium))"
    }

    Illustration(){
        
        Write-Verbose "Defined an illustration"
    }

    Illustration([string]$Name, [string]$Artist) : base($Name, $Artist){
        Write-Verbose "Defined '$Name' by $Artist ($($this.Medium)) as an illustration"

    }

    Illustration([string]$Name,[string]$Artist,[string]$Medium){
        $this.Name= $Name
        $this.Artist= $Artist
        $this.Medium= $Medium

        Write-Verbose "Defined '$Name' by $Artist ($Medium) as an illustration"
    }
}


$Illustrations= @(
    
    [Illustration]@{
        Name   = 'The Funny Thing'
        Artist     = 'Wanda Gag'
        Medium= 'Lithorgraphy'    
    }
    [Illustration]::new('Millions of Cats','Wanda Gag')
    [Illustration]::new(
      'The Lion and the Mouse',
      'Jerry Pinkney',
      'Watercolor'
    )
)

$Illustrations| Format-Table
$Illustrations| ForEach-Object {[Illustration]::RegisterIllustration($_)}
$Illustrations|ForEach-Object {[PublishedWork]::RegisterWork($_)}
"Published work artists: $([PublishedWork]::Artists -join ', ')"
"Illustration artists: $([Illustration]::Artists -join ', ')"


[PublishedWork]::List|ForEach-Object -Process {$_.ToString()}