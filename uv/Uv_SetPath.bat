@echo off
chcp 65001 > NUL
set CURL_CMD=C:\Windows\System32\curl.exe -kL
set PS_CMD=PowerShell -Version 5.1 -NoProfile -ExecutionPolicy Bypass
set EASY_UV_DIR=%~dp0

where /Q uv
if %ERRORLEVEL% equ 0 ( goto :EASY_UV_FOUND )
cd > NUL

if not exist "%~dp0env\uv.exe" (
	setlocal enabledelayedexpansion
    if not exist "%~dp0env\" ( mkdir "%~dp0env" )
    echo https://github.com/astral-sh/uv

	echo %CURL_CMD% -o %~dp0env\uv-x86_64-pc-windows-msvc.zip https://releases.astral.sh/github/uv/releases/download/0.12.5/uv-x86_64-pc-windows-msvc.zip
	%CURL_CMD% -o %~dp0env\uv-x86_64-pc-windows-msvc.zip https://releases.astral.sh/github/uv/releases/download/0.12.5/uv-x86_64-pc-windows-msvc.zip
    if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )

	echo %PS_CMD% Expand-Archive -Path %~dp0env\uv-x86_64-pc-windows-msvc.zip -DestinationPath "%~dp0env" -Force
	%PS_CMD% Expand-Archive -Path %~dp0env\uv-x86_64-pc-windows-msvc.zip -DestinationPath "%~dp0env" -Force
    if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )

	echo del %~dp0env\uv-x86_64-pc-windows-msvc.zip
	del %~dp0env\uv-x86_64-pc-windows-msvc.zip
    if !ERRORLEVEL! neq 0 ( pause & endlocal & exit /b 1 )
	endlocal
)

set "PATH=%EASY_UV_DIR%env;%PATH%"
set UV_CACHE_DIR=%EASY_UV_DIR%env\cache
set UV_PYTHON_INSTALL_DIR=%EASY_UV_DIR%env\python
set UV_TOOL_DIR=%EASY_UV_DIR%env\tools

where /Q uv
if %ERRORLEVEL% equ 0 ( goto :EASY_UV_FOUND )
echo "[Error] UV をインストールできませんでした。手動で UV をインストールしてください。"
pause & exit /b 1

:EASY_UV_FOUND