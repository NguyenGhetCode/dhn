@echo off
cd /d "%~dp0"
set "COURT_NODE=node"
where node >nul 2>&1
if errorlevel 1 (
  if exist "%ProgramFiles%\nodejs\node.exe" (
    set "COURT_NODE=%ProgramFiles%\nodejs\node.exe"
  ) else (
    echo Chua tim thay Node.js. Hay cai Node.js 22.13 tro len va mo lai cua so nay.
    pause
    exit /b 1
  )
)
"%COURT_NODE%" -e "const v=process.versions.node.split('.').map(Number);process.exit(v[0]<22||(v[0]===22&&v[1]<13)?1:0)"
if errorlevel 1 (
  echo Can Node.js 22.13 tro len. Hay cap nhat Node.js roi chay lai.
  pause
  exit /b 1
)
"%COURT_NODE%" local/server.mjs
pause
