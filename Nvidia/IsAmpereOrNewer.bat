@echo off
chcp 65001 > nul
setlocal enabledelayedexpansion

where /Q nvidia-smi
if %ERRORLEVEL% neq 0 (
    echo "[ERROR] nvidia-smi が見つかりません。"
    exit /b 1
)

for /f "tokens=1,2 delims=," %%a in ('nvidia-smi --query-gpu^=name^,compute_cap --format^=csv^,noheader^,nounits') do (
    set "GPU_NAME=%%a"
    set "COMPUTE_CAP=%%b"
)

echo %GPU_NAME% %COMPUTE_CAP%

:: Remove whitespace
set "COMPUTE_CAP=!COMPUTE_CAP: =!"

:: Remove the dot
set "CC_NUM=!COMPUTE_CAP:.=!"

:: <RTX 30 (8.6<)
if !CC_NUM! lss 86 ( exit /b 1 )
