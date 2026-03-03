#!/bin/bash
# Quick push script for PowerShell

# If running in PowerShell:
# Save this as "push.ps1" and run: .\push.ps1

Write-Host "🔄 Committing fixes to GitHub..." -ForegroundColor Green

git add pubspec.yaml
git add QUICK_FIX.md
git commit -m "Fix: Remove incompatible validator package and update dependencies"
git push

Write-Host "✅ Done! Changes pushed to GitHub" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Run: flutter pub get" -ForegroundColor White
Write-Host "2. Run: flutter run -d chrome" -ForegroundColor White
Write-Host ""
Write-Host "App will launch in your browser!" -ForegroundColor Cyan
