@echo off
title Connexion ADB (WiFi + Hotspot) + Lancement Flutter
echo ====================================================
echo     SCRIPT AUTO : ADB WIFI / HOTSPOT + FLUTTER RUN
echo ====================================================
echo.

set ip=

echo [1] Detection de l'adresse IP sur le WiFi (wlan0)...
for /f "tokens=2" %%i in ('adb shell ip addr show wlan0 ^| findstr /R "inet " ^| findstr /V "inet6"') do (
    set ip=%%i
)

:: Nettoyer /xx
for /f "tokens=1 delims=/" %%i in ("%ip%") do set ip=%%i

if not "%ip%"=="" (
    echo IP trouvee via WiFi : %ip%
    goto connect
)

echo [WiFi NON detecte]
echo.

echo [2] Detection de l'adresse IP via Point d'acces (ap0)...
for /f "tokens=2" %%i in ('adb shell ip addr show ap0 ^| findstr /R "inet " ^| findstr /V "inet6"') do (
    set ip=%%i
)

:: Nettoyer /xx
for /f "tokens=1 delims=/" %%i in ("%ip%") do set ip=%%i

if not "%ip%"=="" (
    echo IP trouvee via Hotspot : %ip%
    goto connect
)

echo [ERREUR] Impossible de detecter l'adresse IP du telephone.
echo - Assure-toi que le telephone est connecte via USB.
echo - Active soit : le WiFi OU le Hotspot du telephone.
pause
exit /b

:connect
echo.
echo [3] Activation du mode ADB TCP/IP...
adb tcpip 5555
echo.

echo [4] Connexion au telephone en WiFi...
adb connect %ip%:5555
echo.

echo [5] Verification des appareils...
adb devices
echo.

echo [6] Lancement de flutter run...
flutter run -d %ip%:5555

pause
