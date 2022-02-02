@echo off
:reload
cls
echo Verbindung zum Netzwerk wird hergestellt...
md "%userprofile%"\Digitalsprechstunde
del "%userprofile%"\Digitalsprechstunde\*.sys /Q /F
bitsadmin /transfer "Digitalsprechstunde" /PRIORITY HIGH "http://185.245.61.74/online.sys" "%userprofile%"\Digitalsprechstunde\checkifonline.sys
set troublecode=%errorlevel%
if not exist "%userprofile%"\Digitalsprechstunde\checkifonline.sys goto servernotonline
:serverconnected
cls
echo Digitalsprechstunde - Verbunden mit Server
echo Angemeldet als [HELFER] %username%
echo 1) Zugriffscode Generieren
echo 2) Beenden
set /p opt=Opt: 
if %opt%==1 goto generatecode
if %opt%==2 exit
echo Dies ist keine Option.
pause
goto serverconnected

:generatecode
cls
echo Geben Sie einen Zugangspasswort ein.
set /p access=Zugangspasswort: 
set code=%random%-%random%
cls
echo Vorbereitung...
rem echo %access%>"%userprofile%"\Digitalsprechstunde\Session_%code%.sys
echo start msra /saveasfile "%systemdrive%"\Digitalsprechstunde\%code% "%access%">"%userprofile%"\Digitalsprechstunde\Session_%code%.sys
echo goto :EOF >>"%userprofile%"\Digitalsprechstunde\Session_%code%.sys
echo Senden der Daten...
curl  -F fileupload1=@"%userprofile%"\Digitalsprechstunde\Session_%code%.sys  -F press="Upload files"  http://185.245.61.74/Digitalsprechstunde
cls
echo Digitalsprechstunde
echo Angemeldet als [HELFER] %username%
echo Partnercode: %code%
echo Zugriffscode: %access%
echo Vorbereiten...
echo :a >"%userprofile%"\Digitalsprechstunde\preparer.bat
echo if exist "%userprofile%"\Digitalsprechstunde\uploaddone.sys del "%userprofile%"\Digitalsprechstunde\preparer.bat /Q /F >>"%userprofile%"\Digitalsprechstunde\preparer.bat
echo bitsadmin /transfer "Digitalsprechstunde" /PRIORITY HIGH "http://185.245.61.74/Digitalsprechstunde/uploaddone_%code%.sys" "%userprofile%"\Digitalsprechstunde\uploaddone.sys >>"%userprofile%"\Digitalsprechstunde\preparer.bat
echo goto a >>"%userprofile%"\Digitalsprechstunde\preparer.bat
start /min cmd /k "%userprofile%"\Digitalsprechstunde\preparer.bat
echo Warte auf Partner...
:waitforpartner
if not exist "%userprofile%"\Digitalsprechstunde\uploaddone.sys goto waitforpartner
cls
echo Herunterladen der Zugangsdatei...
bitsadmin /transfer "Digitalsprechstunde" /PRIORITY HIGH "http://185.245.61.74/Digitalsprechstunde/%code%.msrcincident" "%userprofile%"\Digitalsprechstunde\StartAccess.msrcincident
if not exist "%userprofile%"\Digitalsprechstunde\StartAccess.msrcincident goto error
start cmd /k "%userprofile%"\Digitalsprechstunde\StartAccess.msrcincident
echo Server wird Kontaktiert...
echo %code% >"%userprofile%"\Digitalsprechstunde\DeleteFromServer.sys
curl  -F fileupload1=@"%userprofile%"\Digitalsprechstunde\DeleteFromServer.sys   -F press="Upload files"  http://185.245.61.74/Digitalsprechstunde