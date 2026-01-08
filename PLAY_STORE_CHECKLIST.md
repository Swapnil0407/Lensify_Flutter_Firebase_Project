# 🚀 Lensify - Play Store Publishing Checklist

## ✅ Status: Build Ready (Play Console items remaining)

---

## 🔴 CRITICAL CHANGES MADE

### ✔️ 1. Package ID Fixed
- **Changed from:** `com.example.lensify` ❌
- **Changed to:** `com.swapnil.lensify` ✅
- **Status:** ✅ COMPLETED

**Files Updated:**
- ✅ android/app/build.gradle.kts (namespace & applicationId)
- ✅ MainActivity.kt moved to correct package structure

---

## ✅ Firebase Configuration

### Status
- Package ID in Firebase: `com.swapnil.lensify` ✅
- File updated: `android/app/google-services.json` ✅

If you ever change the package ID again, you must repeat the Firebase “Add Android app” step and download a new `google-services.json`.

---

## 🔐 SECURITY ALERT

### ⚠️ Keystore Password EXPOSED

**CRITICAL:** You shared these publicly:
```
Store Pass: lensify123
Key Pass: lensify123
```

### 🛡️ What to Do:

**Option 1 - Before Publishing (RECOMMENDED):**
```powershell
# Create NEW keystore with STRONG passwords
keytool -genkey -v -keystore D:\Flutter\Lensify\android\app\keystore\lensify-release-key-v2.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias lensify
```
- Use STRONG passwords (mix letters, numbers, symbols)
- Update `key.properties`
- **NEVER share passwords again!**

**Option 2 - Already Published:**
- You're locked to this keystore ⚠️
- Keep current passwords SECRET
- Monitor app security closely

---

## 📋 PLAY STORE REQUIREMENTS (MANDATORY)

### ✅ 1. Privacy Policy (REQUIRED)
**Status:** ✅ Completed

Add this in Play Console → Store presence → Main store listing → Privacy policy:
- Privacy Policy URL: https://doc-hosting.flycricket.io/lensify-privacy-policy/3c2bbfe6-6db8-473c-91b2-616348f78966/privacy

Optional (recommended) add Terms link in your store listing description/support section:
- Terms of Use URL: https://doc-hosting.flycricket.io/lensify-terms-of-use/922eb551-4333-4675-9dda-2e0e52178210/terms

**Options:**
- **A. Create simple policy:** Use https://app-privacy-policy-generator.firebaseapp.com/
- **B. Host on GitHub:** Create `privacy-policy.html` in GitHub Pages
- **C. Use Google Sites:** Free hosting

**What to include:**
- Data collection (Firebase Auth, Firestore)
- User data usage
- Third-party services (Firebase, Google)
- Data retention & deletion

📍 **Example URL format:** https://swapnil.github.io/lensify-privacy-policy

---

### 🔴 2. Data Safety Form (REQUIRED)
**Status:** ❌ Not completed

**Go to Play Console → Policy → Data safety**

**What to answer:**
```
✓ Does your app collect user data? → YES
✓ Data types collected:
  - Personal info (Email)
  - App activity (User interactions)
  
✓ Is data encrypted in transit? → YES
✓ Can users request data deletion? → YES (if you provide this)
✓ Is data shared with third parties? → YES (Google/Firebase)
```

---

### 🔴 3. Content Rating (REQUIRED)
**Status:** ❌ Not completed

**Go to Play Console → Policy → App content → Content rating**

Complete questionnaire:
- App category: Shopping
- Interactive elements: Users can share info
- Target age: All ages or 13+

---

### 🔴 4. Target Audience (REQUIRED)
**Status:** ❌ Not completed

**Recommended:**
- **Age group:** 13+ or All ages
- **Appeals to children:** No (unless it's specifically for kids)

---

### 🔴 5. Store Listing Assets (REQUIRED)

#### Screenshots (MINIMUM 2 required)
**Status:** ❌ Missing

**Requirements:**
- Format: PNG or JPEG
- Min size: 320px
- Max size: 3840px
- Aspect ratio: 16:9 or 9:16

**How to capture:**
```dart
// Run app on emulator/device
// Take screenshots of:
// 1. Login/Home screen
// 2. Main features
// 3. Product listing
// 4. Cart/Checkout (if applicable)
```

---

#### Feature Graphic (REQUIRED)
**Status:** ❌ Missing

**Requirements:**
- Size: 1024 x 500 px (EXACT)
- Format: PNG or JPEG
- No transparency

**Quick create:**
- Use Canva: https://www.canva.com/
- Template: "YouTube Thumbnail" → Resize to 1024x500
- Add: App name "Lensify" + tagline + visual

---

#### App Icon
**Status:** ✅ (Assuming you have flutter app icon)

**Requirements:**
- 512 x 512 px
- 32-bit PNG with alpha
- Circular safe zone

---

### 🔴 6. App Access (IF you have login)
**Status:** ❌ Not completed

**If your app requires login:**

**Go to Play Console → Store presence → Main store listing → App access**

**Provide:**
```
✓ Test account email: test@example.com
✓ Test account password: TestPass123
✓ Instructions: Any special steps to test
```

**OR** Select:
- ☐ All functionalities are available without signing in

---

## 🏗️ Build Configuration

### Current Status:
```
App Name:      Lensify ✅
Package ID:    com.swapnil.lensify ✅ (UPDATED)
Version Code:  1 ✅
Version Name:  1.0.0 ✅
Signing:       Configured ✅
```

---

## 📦 BUILD COMMANDS

### After Firebase Update, rebuild:

```powershell
# Clean build
flutter clean
flutter pub get

# Build release AAB
flutter build appbundle --release

# Output location:
# build\app\outputs\bundle\release\app-release.aab

✅ Latest known-good output:
- `build\app\outputs\bundle\release\app-release.aab`
```

---

## 📝 STEP-BY-STEP PUBLISHING GUIDE

### Phase 1: Pre-Publishing (DO NOW)
- [x] ~~Fix package ID~~ ✅ DONE
- [x] Update Firebase (google-services.json) ✅ DONE
- [x] Rebuild AAB ✅ DONE
- [ ] Secure keystore passwords
- [x] Create Privacy Policy page ✅ DONE
- [ ] Take 2+ screenshots
- [ ] Create feature graphic (1024x500)

### Phase 2: Play Console Setup
1. **App Information:**
   - App name: Lensify
   - Default language: English (US)
   - Category: Shopping

2. **Store Listing:**
   - Short description (80 chars)
   - Full description (4000 chars)
   - Upload screenshots
   - Upload feature graphic
   - App icon (auto from AAB)

3. **Privacy & Policy:**
   - Privacy policy URL
   - Complete Data Safety form

4. **Content Rating:**
   - Complete questionnaire
   - Get rating certificate

5. **App Access:**
   - Provide test account OR mark as "no login required"

6. **Pricing & Distribution:**
   - Free/Paid
   - Select countries
   - Content guidelines agreement

### Phase 3: Upload & Review
1. **Upload AAB:**
   - Go to Release → Production
   - Create new release
   - Upload `app-release.aab`
   - Release notes

2. **Review & Submit:**
   - Check all green checkmarks
   - Submit for review (2-7 days)

---

## 🔄 FUTURE UPDATES CHECKLIST

When releasing version 1.1.0:

1. **Update version in build.gradle.kts:**
   ```kotlin
   versionCode = 2        // Always increase by 1
   versionName = "1.1.0"  // Your version number
   ```

2. **Rebuild:**
   ```powershell
   flutter build appbundle --release
   ```

3. **Upload to Play Console:**
   - Production track
   - New release
   - Upload new AAB
   - Add release notes

---

## ⚠️ NEVER LOSE THESE FILES

**Critical files to backup:**
```
✓ android/app/keystore/lensify-release-key.jks
✓ android/key.properties
```

**Backup locations:**
- Google Drive
- External USB
- Password manager (for key.properties content)

**If you lose the signing key:**
- ❌ You can NEVER update your app
- ❌ Must create entirely new app listing
- ❌ Lose all reviews, ratings, downloads

---

## 📊 Current Status Summary

| Item | Status | Priority |
|------|--------|----------|
| Package ID | ✅ Fixed | CRITICAL |
| Firebase Config | ✅ Updated | CRITICAL |
| AAB Build | ✅ Built successfully | CRITICAL |
| Keystore Security | ⚠️ Review before GitHub/Play | HIGH |
| Privacy Policy | ✅ Added | CRITICAL |
| Data Safety | ⏳ Pending in Play Console | CRITICAL |
| Content Rating | ⏳ Pending in Play Console | CRITICAL |
| Screenshots | ⏳ Pending | CRITICAL |
| Feature Graphic | ⏳ Pending | CRITICAL |
| App Access | ⏳ Pending (if login required) | HIGH |

---

## 🎯 IMMEDIATE NEXT STEPS

### TODAY (Priority Order):

1. **Capture Screenshots (30 mins):**
   - Run app
   - Take 2-4 good screenshots
   - Save as PNG

2. **Create Feature Graphic (1 hour):
   - Use Canva
   - 1024x500 px
   - Include app name & visual

3. **Fill Play Console Forms (1-2 hours):
   - Data Safety
   - Content Rating
   - App Access
   - Store Listing

4. **Upload AAB + Create Production Release (15 mins):**
   - Release → Production → Create new release
   - Upload `app-release.aab`
   - Add release notes

### THEN:
- Upload AAB
- Complete all checklists
- Submit for review 🚀

---

## 📞 Need Help?

**Resources:**
- Play Console Help: https://support.google.com/googleplay/android-developer
- Flutter Docs: https://docs.flutter.dev/deployment/android
- Firebase Console: https://console.firebase.google.com

---

## ✅ FINAL CHECKLIST BEFORE SUBMIT

```
Before clicking "Submit for Review":

App Setup:
[ ] Package ID is production-ready (com.swapnil.lensify)
[ ] Firebase updated with new package ID ✅
[ ] AAB built and tested ✅
[ ] Keystore secured

Play Console:
[ ] Privacy Policy URL added
[ ] Data Safety form completed
[ ] Content Rating received
[ ] Target audience selected
[ ] Screenshots uploaded (min 2)
[ ] Feature graphic uploaded (1024x500)
[ ] App access configured
[ ] Store listing complete (descriptions, title)
[ ] Pricing & distribution set

Testing:
[ ] App installs from AAB
[ ] Firebase features work
[ ] No crashes on test devices

---

## 🧾 EXACT INFO YOU MUST PROVIDE IN PLAY CONSOLE (COPY/PASTE CHECKLIST)

### 1) Create App
- App name: Lensify
- Default language: English
- App or game: App
- Free or paid: (choose)
- Declarations: agree to policies

### 2) Store Listing (Store presence → Main store listing)
- App name (same as above)
- Short description (up to 80 chars)
- Full description (up to 4000 chars)
- App icon: 512×512 PNG
- Feature graphic: 1024×500 (required)
- Phone screenshots: minimum 2 (recommended 4–8)
- Contact details (required):
   - Email
   - Website (optional but recommended)

### 3) App Access (App content → App access)
If your app requires login to access core features:
- Provide a test account email + password
- Provide step-by-step testing instructions

If most features work without login:
- Choose the option indicating no special access is needed

### 4) Data Safety (Policy → App content → Data safety)
Be consistent with what the app actually does (Firebase Auth/Firestore/Storage).
Typical answers for Firebase apps:
- Data collected: Email (login), possibly user-generated content/orders
- Data processed: Yes
- Encryption in transit: Yes
- Data deletion: If you support it, say how (email request or in-app)

### 5) Content Rating (App content → Content rating)
- Fill questionnaire
- Save the certificate

### 6) Target Audience (App content → Target audience)
- Usually 13+ for shopping apps unless made for kids

### 7) Ads (App content → Ads)
- Declare whether you show ads

### 8) Privacy Policy
- Paste Privacy Policy URL (see section above)

### 9) Upload Release (Release → Production)
- Create new release
- Upload: `build\app\outputs\bundle\release\app-release.aab`
- Add release notes
- Review & submit

---

## 🔒 IMPORTANT BEFORE UPLOADING TO GITHUB

Do NOT commit these sensitive files:
- `android/app/keystore/*.jks`
- `android/key.properties`

If you want, I can check your `.gitignore` and confirm these are excluded before you push to GitHub.
```

---

**Good luck! 🎉**

*Updated: January 9, 2026*
