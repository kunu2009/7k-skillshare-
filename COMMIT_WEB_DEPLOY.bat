@echo off
setlocal enabledelayedexpansion

echo.
echo ============================================================
echo SKILLSWAP - COMMIT WEB DEPLOYMENT CONFIG TO GITHUB
echo ============================================================
echo.

echo [Step 1] Staging files...
git add vercel.json
git add .vercelignore
git add BUILD_WEB.bat
git add DEPLOY_WEB.bat
git add WEB_DEPLOYMENT_GUIDE.md
git add WEB_DEPLOY_QUICK_START.txt
git add WEB_DEPLOYMENT_ACTION_PLAN.md
git add WEB_DEPLOYMENT_COMPLETE.md
git add START_WEB_DEPLOYMENT.txt

echo [Step 2] Creating commit...
git commit -m "Add web deployment configuration for Vercel

- Added vercel.json for deployment settings
- Added .vercelignore to exclude unnecessary files
- Created BUILD_WEB.bat for building web version
- Created DEPLOY_WEB.bat for interactive deployment
- Added comprehensive web deployment documentation
- Ready for Vercel deployment"

echo [Step 3] Pushing to GitHub...
git push

echo.
echo ============================================================
echo ✓ COMMITTED & PUSHED TO GITHUB!
echo ============================================================
echo.
echo Web deployment files are now on GitHub.
echo.
echo Next: Run .\DEPLOY_WEB.bat to deploy to Vercel
echo.
pause
