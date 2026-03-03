@echo off
echo ========================================
echo Committing and Pushing to GitHub
echo ========================================
echo.

echo [Step 1] Adding all files...
git add .
echo.

echo [Step 2] Committing changes...
git commit -m "Fix: Add Firebase error handling and black screen issue - App now displays loading screen"
echo.

echo [Step 3] Pushing to GitHub...
git push -u origin main
echo.

echo ========================================
echo SUCCESS! Code pushed to GitHub
echo ========================================
echo.

pause
