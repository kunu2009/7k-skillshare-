@echo off
echo ========================================
echo Cleaning duplicate Gradle files
echo ========================================
echo.

cd android

echo Deleting settings.gradle.kts...
if exist settings.gradle.kts (
    del /f settings.gradle.kts
    echo Deleted settings.gradle.kts
) else (
    echo settings.gradle.kts not found
)

echo Deleting build.gradle.kts...
if exist build.gradle.kts (
    del /f build.gradle.kts
    echo Deleted build.gradle.kts
) else (
    echo build.gradle.kts not found
)

cd ..

echo.
echo ========================================
echo Cleanup complete!
echo ========================================
echo.
pause
