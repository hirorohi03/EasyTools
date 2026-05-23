@echo off
chcp 65001 > NUL
set CURL_CMD=C:\Windows\System32\curl.exe -kL
set PS_CMD=PowerShell -Version 5.1 -NoProfile -ExecutionPolicy Bypass

if not exist "%~dp0env\" (
    mkdir "%~dp0..\..\Model\Ollama"
    mkdir "%~dp0env\data\AppData\Local"
)
if exist "%~dp0env\ollama.exe" ( goto :EASY_OLLAMA_FOUND )

set EASY_OLLAMA_URL=https://github.com/ollama/ollama/releases/download/v0.24.0/ollama-windows-amd64.zip
echo %CURL_CMD% -o "%~dp0env\ollama.zip" %EASY_OLLAMA_URL%
%CURL_CMD% -o "%~dp0env\ollama.zip" %EASY_OLLAMA_URL%
if %ERRORLEVEL% neq 0 ( pause & exit /b 1 )

echo %PS_CMD% Expand-Archive -Path "%~dp0env\ollama.zip" -DestinationPath "%~dp0env" -Force
%PS_CMD% Expand-Archive -Path "%~dp0env\ollama.zip" -DestinationPath "%~dp0env" -Force
if %ERRORLEVEL% neq 0 ( pause & exit /b 1 )

echo del "%~dp0env\ollama.zip"
del "%~dp0env\ollama.zip"
if %ERRORLEVEL% neq 0 ( pause & exit /b 1 )

:EASY_OLLAMA_FOUND

set OLLAMA_MODELS=%~dp0..\..\Model\Ollama
set OLLAMA_ORIGINS=*
set OLLAMA_HOST=0.0.0.0
set userprofile=%~dp0env\data
set localappdata=%~dp0env\data\AppData\Local

set "OLLAMA_EXE=%~dp0env\ollama.exe"
start ""  %OLLAMA_EXE% serve

echo Ollamaの起動を待っています...
:LOOP
%OLLAMA_EXE% ps > nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Ollamaが起動しました
    goto :FINISH
)

timeout /t 1 /nobreak > nul
goto :LOOP

:FINISH
