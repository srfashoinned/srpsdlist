Set WshShell = CreateObject("WScript.Shell")

Do
    Set objWMI = GetObject("winmgmts:\\.\root\cimv2")
    Set colProcesses = objWMI.ExecQuery("Select * from Win32_Process Where Name = 'cmd.exe'")

    running = False

    For Each objProcess in colProcesses
        If InStr(objProcess.CommandLine, "auto_update.bat") > 0 Then
            running = True
        End If
    Next

    If running = False Then
        WshShell.Run """C:\Users\SR\Desktop\demmo\auto_update.bat""", 0, False
    End If

    WScript.Sleep 60000   ' check every 60 sec
Loop