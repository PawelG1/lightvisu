# DeckMate - Google Play Launch Checklist

## 🔐 Step 1: Generate Signing Key (DO THIS FIRST!)

```bash
cd /home/mecharolnik/Documents/GitHub/lightvisu/android

keytool -genkey -v -keystore key.jks \
  -keyalg RSA -keysize 2048 -validity 10950 \
  -alias deckmate_key
```

**When prompted, enter:**
```
Keystore password:    [Create STRONG password] e.g., MyStr0ngPass123!
Re-enter password:    [Same as above]
First and last name:  DeckMate
Organization:         [Your Company Name]
City or Locality:     [Your City]
State or Province:    [Your Province]
Country Code:         PL (or your 2-letter code)
CN=DeckMate:          Yes
```

**Result:** Creates `android/key.jks` file

✅ **BACKUP THIS FILE** - Store securely! You'll need it for all future updates!


## 🔑 Step 2: Create Configuration File

```bash
cd /home/mecharolnik/Documents/GitHub/lightvisu

# Copy template to real file
cp android/key.properties.example android/key.properties

# Edit the file with your values
nano android/key.properties
```

**Fill in `android/key.properties`:**
```properties
storePassword=MyStr0ngPass123!
keyPassword=MyStr0ngPass123!
keyAlias=deckmate_key
storeFile=key.jks
```

✅ **VERIFY:** File is in `.gitignore` (it's not committed to git)


## 🏗️ Step 3: Build App Bundle

```bash
cd /home/mecharolnik/Documents/GitHub/lightvisu

# Clean
flutter clean

# Get dependencies
flutter pub get

# Build release bundle
flutter build appbundle --release \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols
```

**Output:**
```
✓ Built build/app/outputs/bundle/release/app-release.aab
```

File size should be < 150 MB. ✅


## 📊 Step 4: Create Google Play Developer Account

1. Visit: https://play.google.com/console
2. Pay registration fee: **$25 USD** (one-time)
3. Complete your profile with business details


## 🎯 Step 5: Create App in Google Play Console

1. Click: **"Create app"**
2. Fill in:
   - **App name:** DeckMate
   - **Default language:** English
   - **App/Game:** App
   - **Free/Paid:** Free
   - **Category:** Education
   - **Content rating:** For all audiences

3. Accept agreements & create


## 🎨 Step 6: Complete Store Listing

### App Icon (required)
- Source: `/assets/img/icons/logoDeckMate.png`
- Size: 512x512px PNG
- Upload in: Graphic assets section

### Screenshots (required - 2-8)
Create and upload screenshots showing:
1. Vessel visualization feature
2. Quiz screen
3. Heading controls
4. Settings/about screen

Recommended resolution: 1080x1920px (9:16 aspect ratio)

### Short Description (required)
```
Maritime Navigation & Sailing Quiz
```

### Full Description (required)
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

PRIVACY & COMPLIANCE:
✓ GDPR Compliant - Full privacy protection
✓ No Ads - Clean experience
✓ Optional Analytics - Help us improve
✓ EU Legal Compliant - Terms & Privacy included

Visit: https://www.deckmate.app
Support: support@deckmate.app
```

### Categorization
- **Category:** Education
- **Content Rating:** Everyone
- **Content Age Rating:** General Audiences (4+)

### Contact Details
- **Support Email:** support@deckmate.app
- **Privacy Policy URL:** https://www.deckmate.app/privacy
- **Website:** https://www.deckmate.app


## 📝 Step 7: App Releases

### Testing (Optional but recommended)
1. Go to: **Release management → Testing**
2. Create **Internal testing** release
3. Upload `app-release.aab`
4. Add test users (your email)
5. Test for 24-48 hours

### Production Release
1. Go to: **Release management → Releases**
2. Click: **Create release**
3. Select: **Production** channel
4. Upload: `app-release.aab` file
5. Add release notes:
   ```
   Version 1.0.0 - Initial Release
   
   • 3D Vessel Visualization
   • Interactive Sailing Quiz
   • Real-time Navigation Teaching
   • GDPR Compliant
   ```
6. Review all information
7. Click: **Send for review**

**Review typically takes:** 2-24 hours


## ✅ Content Rating Questionnaire

When prompted:
- **Violence:** No
- **Sexual Content:** No
- **Ads:** Optional analytics only
- **Alcohol/Tobacco:** No
- **Gambling:** No
- **Restricted Content:** No

**Result:** Everyone (4+) rating


## 📱 Android App Bundle Info

| Property | Value |
|----------|-------|
| App Name | DeckMate |
| Package ID | app.deckmate |
| Version | 1.0.0 |
| Build | 1 |
| Format | Android App Bundle (.aab) |
| Min SDK | 21 (Android 5.0+) |
| Target SDK | Latest stable |
| Signing | Release key |
| Obfuscation | Enabled (ProGuard) |


## 📚 Legal Documents Included

Your app includes:
- ✅ Privacy Policy (GDPR compliant)
- ✅ Terms of Service
- ✅ GDPR Compliance document
- ✅ In-app Terms acceptance screen

Location: `assets/legal/`


## 🔒 Security Checklist

Before uploading:
- ✅ keystore file backed up securely
- ✅ key.properties stored safely (not committed)
- ✅ Passwords stored in password manager
- ✅ Code obfuscated (ProGuard enabled)
- ✅ Debug symbols separated
- ✅ HTTPS only (no cleartext traffic)
- ✅ No hardcoded secrets
- ✅ Permissions justified


## 📊 Monitoring After Launch

After your app goes live:

1. **Check Daily:**
   - Google Play Console home page
   - New ratings & reviews
   - Crash reports

2. **Monitor:**
   - User ratings (aim for 4.0+)
   - Install numbers
   - Uninstall rate
   - Crash statistics

3. **Respond:**
   - Reply to negative reviews
   - Fix reported bugs quickly
   - Release updates every 2-4 weeks


## 🆘 Troubleshooting

### Build fails with "Keystore not found"
- Verify `key.jks` exists in `android/` directory
- Check `key.properties` has correct path

### "Build not uploaded"
- Ensure app bundle is < 150 MB
- Check bundle is in correct format (.aab)
- Verify build is signed correctly

### Review rejected
- Check privacy policy is in app (not just online)
- Ensure terms screen appears on first launch
- Test all features work
- Check no crashes on startup
- Verify content matches description


## 📞 Support Resources

- **Flutter Deployment:** https://flutter.dev/docs/deployment/android
- **Google Play Help:** https://support.google.com/googleplay/
- **Privacy Policy Template:** Our guide includes full example
- **GDPR Compliance:** Check GDPR_COMPLIANCE.md


## 🎯 Success Metrics

Target for first week:
- ✅ App approved and live
- ✅ 100+ installs
- ✅ 4.0+ star rating
- ✅ 0 major crashes
- ✅ Positive user feedback


## 🔄 Future Updates

To update the app:

```bash
# 1. Update version in pubspec.yaml
# version: 1.0.1+2

# 2. Build new bundle
flutter build appbundle --release

# 3. Go to Google Play Console
# 4. Create new release
# 5. Upload new .aab file
# 6. Update release notes
# 7. Submit for review
```

Updates typically go live within 2-4 hours.


---

**Questions?** See `GOOGLE_PLAY_DEPLOYMENT.md` for detailed guide.

**Legal Issues?** Review `assets/legal/` documents.

**Build Issues?** Run `flutter analyze` and check for errors.

Good luck! 🚀
