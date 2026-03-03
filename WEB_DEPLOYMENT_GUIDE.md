# 🌐 SKILLSWAP - WEB DEPLOYMENT TO VERCEL

## ✅ STEP-BY-STEP WEB DEPLOYMENT GUIDE

### Prerequisites:
- [ ] Node.js installed (v18+)
- [ ] GitHub account
- [ ] Vercel account (free)
- [ ] Web version built locally

---

## 🚀 STEP 1: Install Vercel CLI

Open PowerShell and run:

```powershell
npm install -g vercel
```

Verify installation:
```powershell
vercel --version
```

---

## 🏗️ STEP 2: Build Web Version

In your project folder:

```powershell
cd "c:\Desktop\7K\7KAPPS\7K FLUTTER\7k skills share omegle type skill sharing"
flutter clean
flutter pub get
flutter build web --release
```

**Wait for completion** (~10-15 minutes)

**Output will be in:**
```
build/web/
```

---

## 📦 STEP 3: Prepare for Vercel

### Create `vercel.json` in project root:

```json
{
  "buildCommand": "flutter build web --release",
  "outputDirectory": "build/web",
  "framework": "flutter",
  "env": {
    "FLUTTER_WEB_CANVASKIT_URL": "https://www.gstatic.com/flutter-canvaskit/latest/"
  }
}
```

### Create `.vercelignore`:

```
.dart_tool/
build/android/
build/ios/
build/linux/
build/macos/
build/windows/
.git/
.github/
node_modules/
```

---

## 🔐 STEP 4: Environment Variables

Go to Vercel Dashboard → Settings → Environment Variables

Add these if needed:
- `FLUTTER_WEB_USE_SKIA=true`
- `FLUTTER_WEB_CANVASKIT_URL=https://www.gstatic.com/flutter-canvaskit/`

---

## 🌐 STEP 5: Deploy to Vercel

### Option A: Command Line (Easiest)

```powershell
vercel --prod
```

**Follow prompts:**
1. Link to Vercel project (or create new)
2. Confirm settings
3. Deploy

### Option B: GitHub Integration

1. Push to GitHub:
```powershell
git add .
git commit -m "Add web deployment configuration"
git push
```

2. Go to Vercel Dashboard
3. Import project from GitHub
4. Connect repository
5. Deploy

---

## ✅ STEP 6: Verify Deployment

After deployment:
1. Vercel shows you the live URL
2. Click the URL to visit your app
3. Test functionality:
   - [ ] Login page loads
   - [ ] Can sign up
   - [ ] Can sign in with email
   - [ ] Can sign in with Google
   - [ ] Navigation works
   - [ ] Dark mode toggle works
   - [ ] Settings accessible

---

## 🔗 Custom Domain (Optional)

1. In Vercel Dashboard → Settings → Domains
2. Add your custom domain
3. Update DNS settings (instructions on Vercel)
4. Wait for verification (~24 hours)

---

## 🎯 Common Issues & Fixes

### Issue: Firebase Configuration Error
**Solution:** Check `firebase_options.dart` has web config

### Issue: Google Sign-In Not Working
**Solution:** 
1. Go to Google Cloud Console
2. Add your Vercel domain to OAuth redirect URIs
3. Format: `https://your-domain.vercel.app`

### Issue: CORS Errors
**Solution:** 
1. Ensure Firebase CORS settings allow your domain
2. Update Firestore rules if needed

### Issue: Assets Not Loading
**Solution:**
- Assets are automatically included in web build
- Verify `pubspec.yaml` has assets section

---

## 📱 Update Your DNS/Domain

If using custom domain:

```
Type: CNAME
Name: www
Value: cname.vercel.app
```

Or follow Vercel's specific instructions.

---

## 🔄 Redeploy After Changes

After making code changes:

```powershell
git add .
git commit -m "Update: description of changes"
git push

# If using GitHub integration: automatic redeploy
# If using CLI:
vercel --prod
```

---

## 📊 Monitor Your Deployment

Vercel Dashboard shows:
- ✅ Build status
- ✅ Deployment history
- ✅ Analytics
- ✅ Performance metrics
- ✅ Error logs

---

## 🎉 Your Web App is LIVE!

After deployment, you have:
✅ Web app accessible globally
✅ Automatic HTTPS
✅ CDN distribution
✅ Automatic scaling
✅ Analytics and monitoring

---

## 💡 Important Notes

- Web version shares Firebase with mobile app
- Same Firestore database
- Same authentication
- Same user data
- Cross-platform synchronization ✅

---

## 🚀 Quick Deployment Command

For future deployments, just use:

```powershell
vercel --prod
```

That's it! 🌐
