@echo off
setlocal
echo ==========================================================
echo  Antigravity ^& AI Agent Skills - Windows Quick Installer
echo ==========================================================
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" -Scope global
echo.
pause
