cls
class Book{

    #class properties
    [String]      $Title
    [String]      $Author
    [String]      $Synopsis
    [String]      $Publisher
    [datetime] $PublishDate
    [int]             $PageCount
    [String[]]     $Tags

    #Default constructor
    Book(){$this.Init(@{})}
    
    # Convenience constructor from hashtable
    Book([hashtable]$Properties){$this.Init($Properties)}

    #Common constructor for title and author
    Book([String]$Title, [String]$Author){
        $this.Init(@{Title=$Title; Author= $Author})
    }

    # Shared initializer method
    [void] Init([hashtable]$Properties){
        foreach($Property in $Properties.keys){
            $this.$Property= $Properties.$Property
        }
    }

    # Method to calculate reading time as 2 minutes per page
    [timespan]  GetReadingTime(){
        
        if($this.PageCount -le 0){
            throw "Unable to determine reading time from page count."
        }

        $Minutes= $this.PageCount * 2
        return [timespan]::new(0, $Minutes, 0)
    }

    # Method to calculate how long ago a book was published
    [timespan] GetPublishedAge(){
        if($null -eq $this.PublishDate -or $this.PublishDate -eq [datetime]::MinValue){
            
            throw "PublishDate not defined"
        }

        return (Get-Date) - $this.PublishDate
    }

    # Method to return a string representation of the book
    [String] ToString(){
    
        return "$($this.Title) by $($this.Author) ($($this.PublishDate.Year))"
    }

}



#create object

$Book= [Book]::new(@{
    Title              = "The Hobbit"
    Author          = "J.R.R. Tolkien"
    Publisher      = "George Allen & Unwin"
    PublishDate  = "1937-09-21"
    PageCount    = 310
    Tags               = @('Fantasy','Adventure')
})

$Book

$Time= $Book.GetReadingTime()
$Time = @($Time.Hours, 'hours and', $Time.Minutes, 'minutes') -join '  '
$Age= [Math]::Floor($Book.GetPublishedAge().TotalDays / 365.25)

"It takes $Time to read $Book, `nwhich was published $Age years ago."

<#############################################################
Class with Static members
##############################>

# Class with Static members

class BookList{
    # Static property to hold the list of books
    static [System.Collections.Generic.List[Book]] $Books

    # Static method to initialize the list of books. Called in the other static methods to avoid needing to 
    # explicit initialize the value.

    static [void] Initialize() {
        [BookList]:: Initialize($false)
    }

    static [bool] Initialize([bool]$Force){
        
        if([BookList]::Books.count -gt 0 -and -not $Force){
        
            return $false
        }

        [BookList]::Books=[System.Collections.Generic.List[Book]]::new()
        Write-host "I am initialized" 
        return $true
    }

    # Ensure a book is valid for the list
    static [void] Validate([Book]$Book){
        
        $Prefix=@(
            'Book validation failed: Book must be defined with the Title,'
            'Author, and PublishDate properties, but'
        ) -join ' '

        if($null -eq $Book){
        
            throw "Prefix was null"
        }

        if([String]::IsNullOrEmpty($Book.Title)){
            throw "$Prefix Title was not defined"
        }

        if([String]::IsNullOrEmpty($Book.Author)){
            
            throw "$Prefix Author wasn't defined."
        
        }

        if([datetime]::MinValue -eq $Book.PublishDate){
            
            throw "$Prefix PublishDate wasn't defined."
        }
    
    }

   # Static methods to manage the list of books.
   # Add a book if it's not already in the list

   static [void] Add([Book]$Book){
   
        [BookList]::Initialize()
        [BookList]::Validate($Book)
        if([BookList]::Books.Contains($Book)){
            
            throw "Book '$Book' already in the list."
        
        }

        $FindPredicate={
        
            param([Book]$b)

            $b.Title -eq $Book.Title -and
            $b.Author -eq $Book.Author -and
            $b.PublishDate -eq $Book.PublishDate
        }.GetNewClosure()

        if([BookList]::Books.Find($FindPredicate)){
        
            throw "Book '$Book' already in list."
        }

        [BookList]::Books.Add($Book)
   
   }

   # Clear the list of book
   static [void]clear(){
   
        [BookList]::Initialize()
        [BookList]::Books.Clear()
   }

   #Find a specific book using a filtering scriptblock

   ## to understand scriptblock 
   <#
   [BookList]::Find({ param($b) $b.Title -eq "Some Title" })

   { param($b) $b.Title -eq "Some Title" } is a scriptblock

   #>
   static [Book] Find([scriptblock]$Predicate){
   
        [BookList]::Initialize()
        return [BookList]::Books.Find($Predicate)
   }

   # Find every book matching the filtering scriptblock

   static [Book[]] FIndAll([scriptblock]$Predicate){
   
        [BookList]::Initialize()
        return [BookList]::Books.FindAll($Predicate)
   
   }

   # Remove a specific book
   static [void] Remove([Book]$Book){
        
        [BookList]::Initialize()
        [BookList]::Books.Remove($Book)
   }

   # Remove a book by property value.
   static [void] RemoveBy([String]$Property, [String]$Value){
    
        [BookList]::Initialize()
        $Index= [BookList]::Books.FindIndex({
            
            param($b)
            $b.$Property -eq $Value

        
            }.GetNewClosure()
        
        )

        if($Index -ge 0){
        
            [BookList]::Books.RemoveAt($Index)
        }
   
   }

}


$null -eq [BookList]::Books

[BookList]::Add($Book)
[BookList]::Books


[BookList]::Add(
    [Book]::new(@{
    Title       = 'The Fellowship of the Ring'
    Author      = 'J.R.R. Tolkien'
    Publisher   = 'George Allen & Unwin'
    PublishDate = '1954-07-29'
    PageCount   = 423
    Tags        = @('Fantasy', 'Adventure')
    })
)

[BookList]::Find({
    param($b)

    $b.PublishDate -gt '1950-01-01'
}).Title


[BookList]::FIndAll({

    param($b)

    $b.Author -match 'Tolkien'
}).Title


[BookList]::Remove($Book)
[BookList]::Books.Title

[BookList]::RemoveBy('Author','J.R.R. Tolkien')

[BookList]::Add($Book)
[BookList]::Add($Book)