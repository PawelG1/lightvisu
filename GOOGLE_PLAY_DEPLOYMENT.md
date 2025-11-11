# 📱 Google Play Console Deployment Guide - DeckMate

## Phase 1: Pre-Deployment Setup ✅

### 1.1 Legal Compliance (COMPLETED)
- ✅ Privacy Policy (GDPR compliant)
- ✅ Terms of Service
- ✅ GDPR Compliance Document
- ✅ Terms & Conditions acceptance screen
- ✅ Asset icons configured

### 1.2 App Versioning
```yaml
Version: 1.0.0
Build: 1
Name: DeckMate
Package: com.deckmate.app
```

---

## Phase 2: Android Setup (IN PROGRESS)

### 2.1 Create Keystore for Signing

```bash
# Generate keystore (interactive - follow prompts)
keytool -genkey -v -keystore /home/mecharolnik/Documents/GitHub/lightvisu/android/key.jks \
  -keyalg RSA -keysize 2048 -validity 10950 \
  -alias deckmate_key

# Output will be: android/key.jks (KEEP SECURE!)
```

**Important:** 
- Keystore password: Create a STRONG password (store it securely)
- Key alias: `deckmate_key`
- Validity: 10,950 days (~30 years)
- ⚠️ **NEVER commit key.jks to git** - add to .gitignore

### 2.2 Configure Android Signing

Create `android/key.properties`:
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=deckmate_key
storeFile=key.jks
```

⚠️ Add to `.gitignore`:
```
android/key.properties
android/key.jks
```

### 2.3 Update build.gradle.kts

Configure signing in release builds to use keystore.

---

## Phase 3: Build Android App Bundle

```bash
cd /home/mecharolnik/Documents/GitHub/lightvisu

# Clean build
flutter clean
flutter pub get

# Build Android App Bundle (AAB) - for Google Play
flutter build appbundle \
  --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols

# Output: build/app/outputs/bundle/release/app-release.aab
```

**File Size Target:** < 150 MB (Google Play limit: 500 MB for AAB)

---

## Phase 4: iOS Setup

### 4.1 Certificate & Provisioning Profile

1. **Apple Developer Account** (requires paid membership)
2. **Create Certificates:**
   - iOS App Development Certificate
   - iOS Distribution Certificate
3. **Create App ID:** `app.deckmate.DeckMate`
4. **Create Provisioning Profiles:**
   - Development Profile
   - Release/Distribution Profile

### 4.2 Configure Xcode

```bash
cd ios
pod install
open Runner.xcworkspace
```

In Xcode:
- Team: Your Apple Team ID
- Bundle Identifier: `app.deckmate.DeckMate`
- Development Team: Set to your team
- Signing Certificate: Select distribution certificate

### 4.3 Build iOS App

```bash
flutter build ios --release
```

**Output:** 
- `build/ios/iphoneos/Runner.app`
- Upload with Xcode organizer or Transporter

---

## Phase 5: Google Play Console Setup

### 5.1 Create Developer Account

1. Visit: https://play.google.com/console
2. Pay registration fee: $25 (one-time)
3. Complete profile

### 5.2 Create New App

1. **App Name:** DeckMate
2. **Default Language:** English
3. **Category:** Education / Books & Reference
4. **Content Rating:** Everyone / General Audiences
5. **App Type:** Application
6. **Free/Paid:** Free

### 5.3 Set Up Store Listing

**Icon (512x512px):**
- Source: `/assets/img/icons/logoDeckMate.png`
- Format: PNG with transparent background

**Screenshots (Required - 2-8):**
- Create screenshots for key features:
  1. 3D Vessel Visualization
  2. Quiz Screen
  3. Heading Controls
  4. Vessel Information

**Short Description (50 char):**
```
Maritime Navigation & Sailing Quiz
```

**Full Description (4000 chars):**
```
DeckMate is an interactive educational app for learning maritime navigation rules and sailing practices.

Features:
• 3D Interactive Vessel Visualizations - See exactly how different ships appear from all angles
• Comprehensive Sailing Quiz - Test your knowledge of maritime rules and regulations
• Real-time Heading Visualization - Understand ship orientation and navigation
• Multiple Vessel Types - Learn differences between various maritime vessels

Perfect for:
- Students preparing for maritime certifications
- Sailing enthusiasts wanting to learn navigation rules
- Anyone interested in maritime education

DISCLAIMER: DeckMate is an educational tool. It does NOT replace official maritime certifications or professional training. Always consult official maritime authorities for critical decisions.

Privacy & Safety:
✓ GDPR Compliant - Your privacy is protected
✓ No Ads - Clean, distraction-free experience
✓ Optional Analytics - Help us improve
✓ Safe for All Ages - Educational content

Learn more: privacy.deckmate.app
Terms: https://www.deckmate.app/terms
Privacy: https://www.deckmate.app/privacy
```

**Privacy Policy Link:**
```
https://www.deckmate.app/privacy
```

**Email Support:**
```
support@deckmate.app
```

**Website:**
```
https://www.deckmate.app
```

### 5.4 Content Rating Questionnaire

**Category:** Education
- Violence: None
- Sexual Content: None
- Ads: None (optional analytics)
- Restricted Content: None
- Alcohol/Tobacco: None

**Result:** "Everyone" rating

### 5.5 Set Target Audience

- **Children:** No
- **Age Target:** 13+ years old
- **Designed For:** Everyone interested in maritime education

---

## Phase 6: Upload Build to Google Play

### 6.1 Upload Android App Bundle

1. Go to **Release Management → Releases**
2. Click **Create Release**
3. Select **Production** channel (or **Testing** for beta)
4. Upload `app-release.aab`
5. Review app details
6. Submit for review

### 6.2 App Review Process

**Timeline:** 2-24 hours typically
**Review Checklist:**
- ✅ Content appropriateness
- ✅ Privacy policy compliance
- ✅ GDPR compliance
- ✅ No malware/spyware
- ✅ Functionality test

**Common Rejection Reasons (Avoid):**
- ❌ Missing privacy policy
- ❌ No Terms of Service
- ❌ Misleading descriptions
- ❌ Crash on startup
- ❌ Excessive permissions

---

## Phase 7: iOS App Store Setup

### 7.1 Create App in App Store Connect

1. Visit: https://appstoreconnect.apple.com
2. Click "My Apps"
3. Click "+"
4. Create new iOS App
5. **App Name:** DeckMate
6. **Bundle ID:** `app.deckmate.DeckMate`

### 7.2 Fill App Information

**Category:** Education
**Subcategory:** Educational
**Content Rights:** Original

### 7.3 General App Information

**Age Rating:** 4+ (No mature content)
**Privacy Policy URL:** https://www.deckmate.app/privacy
**Support URL:** support@deckmate.app
**Marketing URL:** https://www.deckmate.app

### 7.4 Prepare Submission

- App Preview Videos (optional)
- Screenshots (2-5 per screen size)
- Description
- Keywords
- Support contact

### 7.5 Build Version

1. In Xcode: Archive build
2. Use Transporter to upload `.ipa`
3. Select build in App Store Connect
4. Fill version release notes
5. Submit for review

---

## Phase 8: Post-Launch Monitoring

### 8.1 Analytics Setup

- Google Play Console analytics (automatic)
- Crash reporting (Firebase - if enabled)
- User ratings and reviews

### 8.2 Update Strategy

**Versioning Scheme:**
- Version 1.0.0 → Initial release
- Version 1.0.1 → Bug fixes
- Version 1.1.0 → Minor features
- Version 2.0.0 → Major overhaul

**Update Process:**
1. Update version in `pubspec.yaml`
2. Build and test
3. Update release notes
4. Upload to Google Play / App Store
5. Review and release

---

## 🔐 Security Checklist

- ✅ Keystore backed up securely (NOT on git)
- ✅ Passwords stored in password manager
- ✅ Apple certificates stored in secure location
- ✅ Privacy policy reviewed by legal
- ✅ GDPR compliance verified
- ✅ Data handling practices documented
- ✅ No hardcoded secrets in code
- ✅ HTTPS for all API calls
- ✅ Permission requests justified
- ✅ User data not shared without consent

---

## 📋 Checklist - Ready to Submit?

- [ ] App name: DeckMate
- [ ] Icon configured: 512x512 PNG
- [ ] Version: 1.0.0
- [ ] Build number: 1
- [ ] Privacy Policy: Written and linked
- [ ] Terms of Service: Written and linked
- [ ] GDPR Compliance: Verified
- [ ] Terms screen: Implemented
- [ ] Android signed APK/AAB generated
- [ ] iOS provisioning profiles set
- [ ] Screenshots prepared (2-8)
- [ ] Descriptions written
- [ ] Support email configured
- [ ] Content rating completed
- [ ] No crashes on startup
- [ ] flutter analyze passes
- [ ] flutter build succeeds
- [ ] Testing on devices completed
- [ ] Legal reviewed (if applicable)

---

## 🚀 Quick Start Commands

```bash
# 1. Generate keystore (one-time)
keytool -genkey -v -keystore android/key.jks \
  -keyalg RSA -keysize 2048 -validity 10950 \
  -alias deckmate_key

# 2. Configure signing (one-time)
# Edit android/key.properties with passwords

# 3. Build release APK for testing
flutter build apk --release

# 4. Build release App Bundle for Play Store
flutter build appbundle --release

# 5. Build iOS
flutter build ios --release
```

---

## 📞 Support Resources

- **Google Play Console Help:** https://support.google.com/googleplay/
- **Apple App Store:** https://developer.apple.com/app-store/
- **Flutter Deployment Docs:** https://flutter.dev/docs/deployment
- **GDPR Resources:** https://gdpr-info.eu/

---

**Next Step:** Follow Phase 2.1 to generate your keystore!
