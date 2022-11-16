# PowerShell Lab 3 Script
# This script creates a report that shows the IP configuration and other details of all enabled adapters for the computer

Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object IPEnabled -EQ True | 
Format-List -Property Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder

