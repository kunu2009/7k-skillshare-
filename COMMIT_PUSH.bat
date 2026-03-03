@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo COMMIT & PUSH TO GITHUB
echo ============================================================
echo.

echo Adding all files...
git add .

echo Committing changes...
git commit -m "Feature: Add Google Sign-In, Dark Mode, User Discovery, Settings Screen, and Vercel deployment setup"

echo Pushing to GitHub...
git push -u origin main

echo.
echo ============================================================
echo SUCCESS! CODE PUSHED TO GITHUB
echo ============================================================
echo.
echo Repository: https://github.com/kunu2009/7k-skillshare-
echo.
echo New features:
echo - Google Sign-In authentication
echo - Dark mode / Light mode toggle
echo - User search and discovery
echo - Filter users by teach/learn
echo - Settings screen with help & FAQ
echo - Vercel deployment support
echo - Web version ready
echo.

pause
