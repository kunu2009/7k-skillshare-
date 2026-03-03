#!/bin/bash

# Build web version for Vercel deployment
echo "=== Building Flutter Web App ==="
echo ""

# Clean previous builds
echo "Step 1: Cleaning..."
flutter clean
rm -rf build/web

echo ""
echo "Step 2: Getting dependencies..."
flutter pub get

echo ""
echo "Step 3: Building web version..."
flutter build web --release

echo ""
if [ -d "build/web" ]; then
    echo "✅ Web build successful!"
    echo ""
    echo "Deployment folder: build/web"
    echo ""
    echo "Next steps:"
    echo "1. Install Vercel CLI: npm install -g vercel"
    echo "2. Run: vercel --prod build/web"
    echo "3. Or just: ./deploy_vercel.sh"
else
    echo "❌ Build failed"
    exit 1
fi
