class InventoryItem {
    [string] $Name
    [int]    $Count

InventoryItem() {}
    InventoryItem([string]$Name) {
        $this.Name = $Name
    }
    InventoryItem([string]$Name, [int]$Count) {
        $this.Name  = $Name
        $this.Count = $Count
    }

[string] ToString() {
        return "$($this.Name) ($($this.Count))"
    }
}