@REM @echo off
@REM title Connexion ADB (WiFi + Hotspot) + Lancement Flutter
@REM echo ====================================================
@REM echo     SCRIPT AUTO : ADB WIFI / HOTSPOT + FLUTTER RUN
@REM echo ====================================================
@REM echo.

@REM set ip=

@REM :: Force ADB a cibler l'appareil USB (-d) au cas ou un emulateur tourne
@REM echo [1] Detection de l'adresse IP sur le WiFi (wlan0)...
@REM for /f "tokens=2" %%i in ('adb -d shell ip addr show wlan0 2^>nul ^| findstr /R "inet "') do (
@REM     set ip=%%i
@REM )

@REM :: Nettoyer /xx
@REM if not "%ip%"=="" for /f "tokens=1 delims=/" %%i in ("%ip%") do set ip=%%i

@REM if not "%ip%"=="" (
@REM     echo IP trouvee via WiFi : %ip%
@REM     goto connect
@REM )

@REM echo [WiFi NON detecte]
@REM echo.

@REM echo [2] Detection de l'adresse IP via Point d'acces (ap0)...
@REM for /f "tokens=2" %%i in ('adb -d shell ip addr show ap0 2^>nul ^| findstr /R "inet "') do (
@REM     set ip=%%i
@REM )

@REM :: Nettoyer /xx
@REM if not "%ip%"=="" for /f "tokens=1 delims=/" %%i in ("%ip%") do set ip=%%i

@REM if not "%ip%"=="" (
@REM     echo IP trouvee via Hotspot : %ip%
@REM     goto connect
@REM )

@REM echo [ERREUR] Impossible de detecter l'adresse IP.
@REM echo - Verifie que le telephone est branche en USB.
@REM echo - Active le debogage USB sur le telephone.
@REM echo - Active le WiFi ou le Point d'acces.
@REM pause
@REM exit /b

@REM :connect
@REM echo.
@REM echo [3] Activation du mode ADB TCP/IP sur le port 5555...
@REM adb -d tcpip 5555
@REM timeout /t 2 >nul

@REM echo [4] Connexion sans fil a %ip%...
@REM adb connect %ip%:5555
@REM echo.

@REM echo [5] Tu peux maintenant debrancher le cable USB si tu le souhaites.
@REM echo.
@REM adb devices
@REM echo.

@REM echo [6] Lancement de flutter run (Mode verbeux pour voir Gradle)...
@REM :: Utilisation de l'IP specifique pour eviter tout conflit
@REM flutter run -d %ip%:5555 -v

@REM pause

@echo off
title ADB WiFi/Hotspot Fix
echo ====================================================
echo    DETECTEUR IPV4 : WIFI OU POINT D'ACCES
echo ====================================================

set ip=

:: 1. Tentative sur le WiFi (wlan0)
for /f "tokens=2" %%i in ('adb -d shell "ip -4 addr show wlan0 | grep inet" 2^>nul') do set ip=%%i

:: 2. Si vide, tentative sur le Hotspot (ap0 ou rndis0 pour USB tether)
if "%ip%"=="" (
    for /f "tokens=2" %%i in ('adb -d shell "ip -4 addr show ap0 | grep inet" 2^>nul') do set ip=%%i
)

:: Nettoyage du masque /24 (ex: 192.168.1.15/24 -> 192.168.1.15)
if not "%ip%"=="" for /f "tokens=1 delims=/" %%i in ("%ip%") do set ip=%%i

if "%ip%"=="" (
    echo [ERREUR] Impossible de trouver une IP.
    echo 1. Verifie que le debogage USB est actif.
    echo 2. Verifie que le WiFi ou le Hotspot est ON.
    echo 3. ACCEPTE l'autorisation sur l'ecran du telephone !
    pause
    exit /b
)

echo [+] IP Detectee : %ip%
echo [+] Activation du mode sans fil...
adb disconnect
adb -d tcpip 5555
timeout /t 3 >nul

echo [+] Connexion a %ip%...
adb connect %ip%:5555
timeout /t 2 >nul

echo.
echo === LISTE DES APPAREILS ===
adb devices
echo ===========================
echo.

:: Verifier si l'appareil est "unauthorized"
adb devices | findstr "unauthorized" >nul
if %errorlevel% equ 0 (
    echo [ATTENTION] Ton telephone affiche "unauthorized".
    echo Regarde ton ecran mobile et ACCEPTE la connexion !
    pause
)

echo [+] Lancement de Flutter sur %ip%...
flutter run -d %ip%:5555 -v 
