function welcome {
write-output "Welcome to planet $env:computername Overlord $env:username"
$now = get-date -format 'HH:MM tt on dddd'
write-output "It is $now."
}

function get-cpuinfo {
get-ciminstance cim_processor | format-list -property Manufacturer, Name, CurrentClockSpeed, MaxClockSpeed, NumberOfCores
}

function get-mydisks {
get-physicaldisk | format-table -property Manufacturer, Model, SerialNumber, FirmwareVersion, Size
}