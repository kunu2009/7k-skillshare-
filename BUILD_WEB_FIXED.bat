@echo off
REM ============================================================
REM BUILD WEB - FIX DEPENDENCIES & BUILD
REM ============================================================

echo.
echo ============================================================
echo Cleaning old builds...
echo ============================================================
call flutter clean
call flutter pub cache clean --force

echo.
echo ============================================================
echo Getting updated dependencies...
echo ============================================================
call flutter pub get

echo.
echo ============================================================
echo Building web version (this takes 10-15 minutes)...
echo Please wait...
echo ============================================================
call flutter build web --release

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ============================================================
    echo SUCCESS!
    echo ============================================================
    echo.
    echo Web build complete! Files are in: build/web
    echo.
    echo Next steps:
    echo 1. Run: git add .
    echo 2. Run: git commit -m "Fix Firebase and build web"
    echo 3. Run: git push origin main
    echo 4. Run: vercel --prod
    echo.
) else (
    echo.
    echo ============================================================
    echo BUILD FAILED
    echo ============================================================
    echo.
    echo Error: Web build failed. Check the errors above.
    echo.
)

pause
