' save HOST_CLIP to C:
command = "powershell.exe -nologo -command C:\HOST_CLIP\pcInfo.ps1"
 set shell = CreateObject("WScript.Shell")
 shell.Run command,0

' create shorcut fom here
 