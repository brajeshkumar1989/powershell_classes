#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
cls
# Defining a class with the default constructor

class ExampleBook1{
    [string] $Name
    [string] $Author
    [int] $Pages
    [datetime] $PublishedOn
}

[ExampleBook1]::new()

Write-Host "---------------------------------ExampleBook1" -ForegroundColor Yellow
# Overriding the default constructor

class ExampleBook2{
    [string] $Name
    [string] $Author
    [int] $Pages
    [datetime] $PublishedOn


    ExampleBook2(){
        $this.PublishedOn=(Get-Date).Date
        $this.Pages          = 1
    }
}

[ExampleBook2]::new()
Write-Host "---------------------------------ExampleBook2" -ForegroundColor Yellow

# Defining constructor overloads

class ExampleBook3{

    [string] $Name
    [string] $Author
    [int] $Pages
    [datetime] $PublishedOn

    ExampleBook3([hashtable]$Info){

        switch($Info.keys){
            'Name'                   {$this.Name              = $Info.Name}
            'Author'                  {$this.Author             = $Info.Author}
            'Pages'                  {$this.Pages              = $Info.Pages}
            'PublishedOn'        {$this.PublishedOn   = $info.PublishedOn}
        }  
    }

    ExampleBook3([string] $Name,[string] $Author, [int] $Pages,[datetime] $PublishedOn){
        
        $this.Name              = $Name
        $this.Author             = $Author
        $this.Pages              =$Pages
        $this.PublishedOn   = $PublishedOn    
    }

    ExampleBook3([string]$Name,[string]$Author){
            
        $this.Name   = $Name
        $this.Author  = $Author
    }

    ExampleBook3(){}
}

[ExampleBook3]::new(@{
    Name   = 'The Hobbit'
    Author  = 'J.R.R. Tolkien'
    Pages  = 310
    PublishedOn = '1937-09-21'
})

[ExampleBook3]::new('The Hobbit', 'J.R.R. Tolkien', 310, '1937-09-21')
[ExampleBook3]::new('The Hobbit', 'J.R.R. Tolkien')
[ExampleBook3]::new()
Write-Host "---------------------------------ExampleBook3" -ForegroundColor Yellow

# Chaining constructors with a shared method 

class ExampleBook4{

    [string] $Name
    [string] $Author
    [datetime] $PublishedOn
    [int] $Pages

    ExampleBook4(){
        
        $this.Init()
    }

    ExampleBook4([string]$Name){
        
        $this.Init($Name)
    }

    ExampleBook4([string]$Name, [string]$Author){
        
        $this.Init($Name, $Author)
     }

     ExampleBook4([string]$Name, [string]$Author,[datetime]$PublishedOn){
        
        $this.Init($Name, $Author, $PublishedOn)
     }

     ExampleBook4([string]$Name, [string]$Author,[datetime]$PublishedOn,[int]$Pages){
        
        $this.Init($Name, $Author, $PublishedOn, $Pages)
     }

     hidden Init(){
        $this.Init('Unknown')
     }
     hidden Init([string]$Name){
     Write-Host "String" -ForegroundColor Cyan
        $this.Init($Name,'Unknown')
     }
     hidden Init([string]$Name,[string]$Author){
        $this.Init($Name, $Author,(Get-Date).Date)
     }

     hidden Init([string]$Name, [string]$Author,[datetime]$PublishedOn){
        $this.Init($Name, $Author, $PublishedOn, 1)
     }

     hidden Init([string]$Name, [string]$Author, [datetime]$PublishedOn,[int]$Pages){
        $this.Name            =$Name
        $this.Author           =$Author
        $this.PublishedOn =$PublishedOn
        $this.Pages            = $Pages
     }
}

[ExampleBook4]::new()
[ExampleBook4]::new('The Hobbit')
[ExampleBook4]::new('The Hobbit','J.R.R Tolkien')
[ExampleBook4]::new('The Hobbit','J.R.R. Tolkien',(Get-Date '1937-9-21'))
[ExampleBook4]::new('The Hobbit','J.R.R. Tolkin',(Get-Date '1937-9-21'), 310)
Write-Host "---------------------------------ExampleBook4" -ForegroundColor Yellow

# Derived class constuctors 

class BaseExample{
    static [void] DefaultMessage([type]$Type){

        Write-Verbose "[$($Type.Name)] default constructor"
    }

    static [void] StaticMessage([type]$Type){
        
        Write-Verbose "[$($Type.Name)] static constructor"
    }

    static [void] ParamMessage([type]$Type,[Object]$Value){
        
        Write-Verbose "[$($Type.Name)] param constructor ($Value)"
    }

    static BaseExample() {[BaseExample]::StaticMessage([BaseExample])}

    BaseExample() {[BaseExample]::DefaultMessage([BaseExample])}
    BaseExample($Value) {[BaseExample]::ParamMessage([BaseExample],$Value)}
}

class DerivedExample : BaseExample{

    static DerivedExample()  {[BaseExample]::StaticMessage([DerivedExample])}
              DerivedExample() {[BaseExample]::DefaultMessage([DerivedExample])}

    DerivedExample([int]$Number) : base($Number){
        
        [BaseExample]::ParamMessage([DerivedExample], $Number)
    }

    DerivedExample([string] $String){
        [BaseExample]::PramMessage([DerivedExample], $String)
    }
}

$VerbosePreference='Continue'
$b=[BaseExample]::new()

$b= [BaseExample]::new(1)

<#

class <class-name> {
    static [hashtable[]] $MemberDefinitions = @(
        @{
            Name       = '<member-name>'
            MemberType = '<member-type>'
            Value      = <member-definition>
        }
    )

static <class-name>() {
        $TypeName = [<class-name>].Name
        foreach ($Definition in [<class-name>]::MemberDefinitions) {
            Update-TypeData -TypeName $TypeName @Definition
        }
    }
}
#>