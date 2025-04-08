cls
Import-Module ./GenericExample.psd1

$Inventory = [Inventory]::new()
$Inventory.GetType() | Format-List -Property Name, BaseType

$Inventory.Add([InventoryItem]::new('Bucket', 2))
$Inventory.Add([InventoryItem]::new('Mop'))
$Inventory.Add([InventoryItem]@{ Name = 'Broom' ; Count = 4 })
$Inventory