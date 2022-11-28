# PowerShell Lab 4 Script
# This script collects and reports system information

# Collecting system hardware description (win32_computersystem)
function osDescription {
    "=== Operating System Hardware Description ==="
    gwmi win32_computersystem | Format-List Description
}

osDescription

# Collecting OS name and version number (win32_operatingsystem)
function osNameVersion {
    "=== Operating System Name and Version ==="
    gwmi win32_operatingsystem | Format-List @{n ="OS Name";e={$_.Caption}}, Version
}

osNameVersion

# Collecting processor description with speed, number of cores and sizes of the L1, L2, L3 caches if they are present (win32_processor)
function processorInfo {
    "=== Processor Information ==="
    $cacheOne = (gwmi win32_processor).L1CacheSize
    if ($cacheOne -eq $null) {
        $cacheOne = "Empty / Does not exist"
    }

    $cacheTwo = (gwmi win32_processor).L2CacheSize
    if ($cacheTwo -eq $null) {
        $cacheTwo = "Empty / Does not exist"
    }
    
    $cacheThree = (gwmi win32_processor).L3CacheSize
    if ($cacheThree -eq $null) {
        $cacheThree = "Empty / Does not exist"
    }

    gwmi win32_processor | fl @{n = "Current Clock Speed (GHz)"; e= {$_.CurrentClockSpeed}}, NumberOfCores, 
    @{n = "L1 Cache Size (bytes)";e = {$cacheOne}},
    @{n = "L2 Cache Size (bytes)";e = {$cacheTwo}}, 
    @{n = "L3 Cache Size (bytes)";e= {$cacheThree}}
}

processorInfo

# Collecting RAM summary (win32_physicalmemory) (vendor, description, size, bank and slot for each DIMM
# Reporting as a table, and the total RAM installed as a summary line after the table
function ramSummary {
    "=== RAM Information ==="
    $totalcapacity = 0
    gwmi win32_physicalmemory | 
    foreach {
        new-object -TypeName psobject -Property @{
        Manufacturer = $_.manufacturer
        "Speed(MHz)" = $_.speed
        "Size(MB)" = $_.capacity/1mb
        Bank = $_.banklabel
        Slot = $_.devicelocator
        }
    $totalcapacity += $_.capacity/1mb
    } |
    ft -auto Manufacturer, "Size(MB)", "Speed(MHz)", Bank, Slot
    "Total RAM: ${totalcapacity}MB "
}

ramSummary

# Include summary of disk drives (vendor, model, size, and percentage free) as a table
 function diskSummary {
    "=== Disk Information ===" 
  $diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Location=$partition.deviceid
                                                               Drive=$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               }
           }
      }
  }
}

diskSummary

# Including lab 3 network adapter configuration report script
function networkSummary {
    "=== Network Information ==="
    C:\Users\Matthew\Documents\GitHub\COMP2101\powershell\ipconfigreport.ps1
}

networkSummary

# Include video card vendor, description, and current resolution (horizontal x vertical) (win32_videocontroller)
function videoSummary {
    "=== Display Information ==="
    [string]$horizontalres = $(gwmi win32_videocontroller).CurrentHorizontalResolution
    [string]$verticalres = $(gwmi win32_videocontroller).CurrentVerticalResolution
    $screenres = $horizontalres + ' x ' + $verticalres
    gwmi win32_videocontroller | Fl @{n ="Vendor";e={$_.AdapterCompatibility}}, Description, @{n = 'Screen Resolution'; e = {$screenres}}
}

videoSummary
