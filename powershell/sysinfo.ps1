# PowerShell Lab 4 Script
# This script collects and reports system information
# eg. get-wmiobject win32_networkadapter)[0, 2, 5] ; we dont get errors for empty index values.
# we can use (get-wmiobject win32_networkadapter).count to know number of index. We can assign a collection to a variable

# Collecting system hardware description (win32_computersystem)
$osDescription = Get-WmiObject -Class win32_computersystem | Format-List Description

# Collecting OS name and version number (win32_operatingsystem)
$osNameVersion = Get-WmiObject -Class win32_operatingsystem | Format-List -Property @{n ="OSName";E={$_.Caption}}, Version

# Collecting processor description with speed, number of cores and sizes of the L1, L2, L3 caches if they are present (win32_processor)
$processorInfo = Get-WmiObject -Class win32_processor | format-list -property CurrentClockSpeed, NumberOfCores
$cacheSizes = gwmi win32_processor | fl L1CacheSize, L2CacheSize, L3CacheSize

# Collecting RAM summary (vendor, description, size, bank and slot for each DIMM REFER SLIDE !!
# Report as a table, and the total RAM installed as a summary line after the table
# (win32_physicalmemory)
$totalcapacity = 0
function ramInfo {
    get-wmiobject -class win32_physicalmemory | 
    foreach {
        new-object -TypeName psobject -Property @{
        Manufacturer = $_.manufacturer
        "Speed(MHz)" = $_.speed
        "Size(MB)" = $_.capacity/1mb
         Bank = $_.banklabel
         Slot = $_.devicelocator
         }
         $totalcapacity += $_.capacity/1mb
        }
}
ft -auto Manufacturer, "Size(MB)", "Speed(MHz)", Bank, Slot
"Total RAM: ${totalcapacity}MB "

# Include summary of disk drives (vendor, model, size, and percentage free) as a table
# Need to use nested loop (on github site)

# Include lab 3 network adapter script

# Include video card vendor, description, and current resolution (horizontal x vertical) (win32_videocontroller)
[string]$Horizontal = $(gwmi win32_videocontroller).CurrentHorizontalResolution
[string]$Vertical = $(gwmi win32_videocontroller).CurrentVerticalResolution

$Resolution = $Horizontal + 'x' + $Vertical; $test
