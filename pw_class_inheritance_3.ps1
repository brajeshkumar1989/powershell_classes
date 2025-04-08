cls
# Inherit from a generic base class.

# Using built-in class as the type parameter
class ExampleStringList : System.Collections.Generic.List[string] {}

$List = [ExampleStringList]::new()
$List.AddRange([string[]]@('a','b','c'))
$List.GetType() | Format-List -Property Name, BaseType
$List




class ExampleItem {
    [string] $Name
    [string] ToString() { return $this.Name }
}

class ExampleItemList : System.Collections.Generic.List[ExampleItem] {}

#above classes will throw runtime error as it is not yet loaded ExampleItem


$List = [ExampleItemList]::new()
$List.AddRange([ExampleItem[]]@(
    [ExampleItem]@{ Name = 'Foo' }
    [ExampleItem]@{ Name = 'Bar' }
    [ExampleItem]@{ Name = 'Baz' }
))
$List.GetType() | Format-List -Property Name, BaseType
$List
