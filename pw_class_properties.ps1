cls
#Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
# Example1: Minimal class properties

class ExampleProject1{
    
    [String]    $Name
    [int]          $Size
    [bool]       $Completed
    [String]     $Assignee
    [datetime] $StartDate
    [datetime] $EndDate
    [datetime] $DueDate
}

[ExampleProject1]::new()

$null -eq ([ExampleProject1]::new()).Name


#Example2: Class properties with custom types

enum ProjectState{

    NotTriaged
    ReadyForWork
    Committed
    Blocked
    InProgress
    Done
}


class ProjectAssignee{

    [string] $DisplayName
    [string] $UserName

    [string] ToString(){
        
        return "$($this.DisplayName)  ($($this.UserName))"
    }
}
Write-Host "------------------------------------------ExampleProject2" -ForegroundColor Yellow

class ExampleProject2{

    [string]                   $Name
    [int]                        $Size
    [ProjectState]        $State
    [ProjectAssignee]  $Assignee
    [datetime]              $StartDate
    [datetime]              $EndDate
    [datetime]              $DueDate

}

Write-Host "------------------------------------------ExampleProject2" -ForegroundColor Yellow

[ExampleProject2]@{
    
    Name ="Class Property Documentation"
    Size= 8
    State= "InProgress"
    Assignee= @{
        DisplayName= 'Mikey Lombardi'
        UserName= 'michaeltlombardi'
    }

    StartDate= '2023-10-23'
    DueDate='2023-10-27'
}

Write-Host "------------------------------------------ExampleProject3" -ForegroundColor Yellow

# Example3: Class property with a validation attribute
class ExampleProject3{

                                         [string]     $Name
    [ValidateRange(0, 16)] [int]          $Size
                                        [bool]       $Completed
                                        [string]     $Assignee
                                        [datetime] $StartDate
                                        [datetime] $EndDate
                                        [datetime] $DueDate
}


$project=[ExampleProject3]::new()
$project
$project.Size=2
$project
Write-Host "------------------------------------------ExampleProject4" -ForegroundColor Yellow

#Example4: Class property with an explicit default.

class ExampleProject4{

    [string]  $Name
    [int]       $Size
    [bool]    $Completed
    [string]  $Assignee
    [datetime]  $StartDate= (Get-Date).Date
    [datetime]  $EndDate
    [datetime]  $DueDate
}

[ExampleProject4]::new()


write-host "[ExampleProject4]::new().StartDate -eq (Get-Date).Date ::"
[ExampleProject4]::new().StartDate -eq (Get-Date).Date


Write-Host "------------------------------------------ExampleProject6" -ForegroundColor Yellow

#Example5- Static class property
class ExampleProject6{
    [string] $Name
    [int]      $Size
    [bool]   $Completed
    [string] $Assignee
    [datetime] $StartDate
    [datetime] $EndDate
    [datetime] $DueDate

    hidden [string]  $Guid= (new-Guid).Guid
    static  [ExampleProject6[]] $Projects= @()

    ExampleProject6(){
        [ExampleProject6]::Projects +=$this
    }

}

"Project Count: $([ExampleProject6]::Projects.Count)"

$project1=[ExampleProject6]@{Name='Project_1'}
$project2=[ExampleProject6]@{Name='Project_2'}

[ExampleProject6]::Projects | Select-Object -Property Name, Guid
"Project Count: $([ExampleProject6]::Projects.Count)"


Write-Host "------------------------------------------ExampleProject7" -ForegroundColor Yellow
# Example7: Defining a property in the constructor

class ExampleProject7{

    [string]   $Name
    [int]        $Size
    [bool]     $Completed
    [string]   $Assignee
    [datetime] $StartDate
    [datetime] $EndDate
    [datetime] $DueDate

    static [hashtable[]] $MemberDefinitions =@(
        @{
        
            MemberName='Duration'
            MemberType='ScriptProperty'
            value={
                    
                    [datetime]$UnsetDate= 0

                    $StartNotSet = $this.StartDate -eq $UnsetDate
                    $EndNotSet= $this.EndDate -eq $UnsetDate
                    $StartAfterEnd= $this.StartDate -gt $this.EndDate

                    if($StartNotSet -or $EndNotSet -or $StartAfterEnd){
                        return $null
                    }

                    return $this.EndDate - $this.StartDate
        
            }
        }   
    )

    static ExampleProject7(){
    
        $TypeName= [ExampleProject7].Name
        foreach($Definition in [ExampleProject7]::MemberDefinitions){
            Update-TypeData -TypeName $TypeName @Definition
        }
    }

    ExampleProject7(){}

    ExampleProject7([string]$Name){
        $this.Name= $Name
    }
}

$Project=[ExampleProject7]::new()
$Project

$null -eq $Project.Duration

$Project.StartDate = '01-01-2023'
$Project.EndDate   = '01-08-2023'

$Project

Write-Host "---------------------------------------------------------BaseClass" -ForegroundColor Yellow

# Derived class properties
class BaseClass{

    static [string] $StaticProperty='Static'
    [string] $InstanceProperty='Instance'

}

class DerivedClassA : BaseClass {}
class DerivedClassB: BaseClass{}
class DerivedClassC: DerivedClassB{
    [string] $InstanceProperty
}

class DerivedClassD: BaseClass{

    static [string] $StaticProperty='Override'
    [string] $InstanceProperty='Override'

}

"Base instance => $([BaseClass]::new().InstanceProperty)"
"Derived instance A => $([DerivedClassA]::new().InstanceProperty)"
"Derived instance B => $([DerivedClassB]::new().InstanceProperty)"
"Derived instance C => $([DerivedClassC]::new().InstanceProperty)"
"Derived instance D => $([DerivedClassD]::new().InstanceProperty)"
Write-Host "=======================================" -ForegroundColor Yellow
"Base static => $([BaseClass]::StaticProperty)"
"Derived static A => $([DerivedClassA]::StaticProperty)"
"Derived static B => $([DerivedClassB]::StaticProperty)"
"Derived static C => $([DerivedClassC]::StaticProperty)"
"Derived static D => $([DerivedClassD]::StaticProperty)"


Write-Host "-------------------------------------------------------------------" -ForegroundColor Yellow
[DerivedClassA]::StaticProperty = 'Updated from A'
"Base static => $([BaseClass]::StaticProperty)"
"Derived static A => $([DerivedClassA]::StaticProperty)"
"Derived static B => $([DerivedClassB]::StaticProperty)"
"Derived static C => $([DerivedClassC]::StaticProperty)"
"Derived static D => $([DerivedClassD]::StaticProperty)"


Write-Host "-------------------------------------------------------------------TestUpdateTypeData" -ForegroundColor Yellow

# Defining instance properties with Update-TypeData

class TestUpdateTypeData{
    
    static [hashtable[]] $MemberDefinitions = @(
        @{
            
            MemberName='Name'
            MemberType='ScriptProperty'
            value={
                return "Brajesh"
            }
        }
    )

    static TestUpdateTypeData(){
        $TypeName=[TestUpdateTypeData].Name
        foreach($Definition in [TestUpdateTypeData]::MemberDefinitions){
            
            Update-TypeData -TypeName $TypeName @Definition
        }
    }
}

$Test=[TestUpdateTypeData]::new()
$Test

Write-Host "-------------------------------------------------------------------OperablePair" -ForegroundColor Yellow

#Property name dynamic - Alias

class OperablePair{

    [int] $x
    [int] $y

    static [hashtable[]] $MemberDefinitions=@(
    
    @{
    
            MemberType='AliasProperty'
            MemberName= 'LeftHandSide'    
            Value= 'x'
        }
    @{
    
            MemberType='AliasProperty'
            MemberName= 'RightHandSide'    
            Value= 'y'
        }
    )

    static OperablePair(){
    
        $TypeName=[OperablePair].Name
        foreach($Definition in [OperablePair]::MemberDefinitions){
            
            Update-TypeData -TypeName $TypeName @Definition
        }
    }

    OperablePair(){}

    OperablePair([int]$x,[int]$y){
    
        $this.x= $x
        $this.y= $y
    }

    # Math methods for the pair of values

    [int] GetSum() {return $this.x + $this.y}
    [int]   GetProduct()    { return $this.x * $this.y }
    [int]   GetDifference() { return $this.x - $this.y }
    [float] GetQuotient()   { return $this.x / $this.y }
    [int]   GetModulus()    { return $this.x % $this.y }

}

$Pair=[OperablePair]@{x=8; RightHandSide=3}

"$($Pair.x) % $($Pair.y) = $($Pair.GetModulus())"

$Pair.LeftHandSide =3
$Pair.RightHandSide=2

"$($Pair.x) x $($Pair.y) = $($Pair.GetProduct())"

Write-Host "-------------------------------------------------------------------Budget" -ForegroundColor Yellow

class Budget{

    [float[]] $Expenses
    [float[]] $Revenues

    static [hashtable[]] $MemberDefinitions=@(
        
        @{
            MemberType='ScriptProperty'
            MemberName='TotalExpenses'
            Value ={($this.Expenses | Measure-Object -Sum).Sum }
        }
        @{
            MemberType='ScriptProperty'
            MemberName='TotalRevenues'
            Value ={($this.Revenues | Measure-Object -Sum).Sum }
        }
        @{
            MemberType='ScriptProperty'
            MemberName='NetIncome'
            Value ={$this.TotalRevenues - $this.TotalExpenses}
        }
    )

    static Budget(){
        
        $TypeName=[Budget].Name
        foreach($Definition in [Budget]::MemberDefinitions){
            Update-TypeData -TypeName $TypeName @Definition
        }    
    }

    Budget(){}

    Budget($Expenses, $Revenues){
        $this.Expenses= $Expenses
        $this.Revenues= $Revenues
    }
}

[Budget]::new()

[Budget]@{
    Expenses= @(2500,1931, 3700)
    Revenues= @(2400,2100, 4150)
}

# Defining properties with custom get and set logic

Write-Host "-------------------------------------------------------------------ProjectSize" -ForegroundColor Yellow

class ProjectSize{
    
    hidden [validateSet(0,1,2,3)] [int] $_value

    static [hashtable[]] $MemberDefinitions=@(
        @{
        
            MemberType='ScriptProperty'
            MemberName='Value'
            Value= {$this._value} #Getter

            SecondValue={
                $ProposedValue=$args[0]

                if($ProposedValue -is [string]){
                    switch($ProposedValue){
                        'Small' {$this._value =1; break}
                        'Medium' {$this._value =2; break}
                        'Large' {$this._value=3; break}
                        default {throw "Unknown size '$proposedValue'"}
                    }
                } else{
                    $this._value= $ProposedValue
                }
            }
        }
    )

    static ProjectSize(){
        
        $TypeName=[ProjectSize].Name
        foreach($Definition in [ProjectSize]::MemberDefinitions){
            Update-TypeData -TypeName $TypeName @Definition
        }
    
    }

    ProjectSize(){}
    ProjectSize([int]$Size){$this.Value=$Size}
    ProjectSize([string]$Size){$this.Value= $Size}

    [string] ToString(){
        $Output= switch($this._value){
            1  {'Small'}
            2  {'Medium'}
            3  {'Large'}
            default {'Undefined'}
        }

        return $Output
    }
}


$size=[ProjectSize]::new()
"The initial size is: $($size._value), $size"

$size.Value = 1
"The defined size is: $($size._value), $size"

$Size.Value += 1
"The updated size is: $($size._value), $size"

$Size.Value = 'Large'
"The final size is:   $($size._value), $size"