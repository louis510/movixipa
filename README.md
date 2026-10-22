# MovixTV – tvOS Re‑implementation

## Project Overview
- **Root folder**: `C:\Users\boulo\Downloads\MovixTV`
- **Architecture** (SwiftUI + Combine)
  - `Models/` – data structures (`Movie.swift`)
  - `Services/` – networking (`APIService.swift`)
  - `ViewModels/` – observable UI logic (`HomeViewModel.swift`)
  - `Views/` – UI screens (`HomeView.swift`, `MovieCardView.swift`, `DetailView.swift`)
  - `Extensions/` – reusable UI helpers (`VisualEffectBlur.swift`)
  - `Resources/` – asset catalog, colors, launch screen
  - `App.swift` – entry point
- **Distin folder** (outside repo) – store design mock‑ups, glass‑style guidelines, extracted Android assets:
  - `C:\Users\boulo\Downloads\Distin\LiquidGlassMockups`

## How to Build & Run
1. Open `MovixTV.xcodeproj` (create an Xcode project pointing at the folder). Set the target to **tvOS**.
2. Add the `Assets.xcassets` catalog under `Resources/`.
3. Set the **App Transport Security** exception or use HTTPS endpoints for your Movix backend.
4. Run on the tvOS Simulator or a physical Apple TV.

## Navigation Flow
- `HomeView` displays a horizontal carousel of `MovieCardView`.
- Selecting a card (press OK) pushes `DetailView`.
- The `DetailView` shows a blurred backdrop, poster, description and a **Play** button that launches an `AVPlayerViewController`.

The navigation is handled by a `NavigationView` wrapper you can add to `App.swift`:
```swift
WindowGroup {
    NavigationView {
        HomeView()
    }
}
```
(Already present in the scaffold; just wrap if you prefer.)

## Liquid‑Glass Styling
All glass‑style overlays use `VisualEffectBlur` (a thin `UIViewRepresentable`).
- Adjust the `intensity` parameter for subtle vs. strong blur.
- The overlay opacity changes with focus (`isFocused ? 0.45 : 0.3`).
- Focus scaling and shadow give the classic tvOS “focus‑zoom”.
- You can reuse this pattern for any card‑like view.

## Extracting Assets from the Android APK
The repository contains the compiled Android package:
- `C:\Users\boulo\Downloads\MovixOpenSource-mainc\MovixOpenSource-main\app-tv\movix-tv.apk`

### Steps (PowerShell)
```powershell
# 1️⃣ Create a temporary folder
$apk = "C:\Users\boulo\Downloads\MovixOpenSource-mainc\MovixOpenSource-main\app-tv\movix-tv.apk"
$out = "C:\Users\boulo\Downloads\Distin\apk_contents"
New-Item -ItemType Directory -Force -Path $out

# 2️⃣ Unzip the APK (APK is a zip archive)
Expand-Archive -Path $apk -DestinationPath $out -Force

# 3️⃣ Locate drawables (icons, posters) – they live in res/drawable* directories
Get-ChildItem -Path $out\res\drawable* -File | Select-Object FullName
```
Copy the images you need into `MovixTV/Resources/Assets.xcassets` (drag‑and‑drop in Xcode). Rename them appropriately (e.g., `AppIcon`, `PosterPlaceholder`).

### Finding API endpoints
Open the de‑compiled Java/Kotlin sources (in `app-tv/src/main/java/...`) or inspect `AndroidManifest.xml` inside the APK:
```powershell
# Extract the manifest
$manifest = Join-Path $out "AndroidManifest.xml"
Get-Content $manifest
```
Look for `<meta-data>` tags or URLs used in Retrofit service definitions (`@GET("movies/home")`). Those paths map directly to the Swift `APIService` endpoints you already have.

## Next‑step Checklist (you can tick them off)
- [ ] Create an Xcode project and add the files above.
- [ ] Add the `Assets.xcassets` catalog & import images from the APK.
- [ ] Configure `Info.plist` for network (NSAppTransportSecurity if needed).
- [ ] Test the home carousel – focus should smoothly scale and blur.
- [ ] Implement navigation to `DetailView` (wrap `HomeView` in `NavigationView`).
- [ ] Verify video playback (replace the placeholder stream URL with a real one).
- [ ] Polish colors: dark theme, red accents – add to `Resources/Colors.colorset`.
- [ ] Review the Glass‑style mock‑ups in `Distin\LiquidGlassMockups` and tweak `intensity`/`blurStyle`.

---
### Quick Reference Links
- **Data model** – [`Movie.swift`](file:///C:/Users/boulo/Downloads/MovixTV/Models/Movie.swift)
- **Network layer** – [`APIService.swift`](file:///C:/Users/boulo/Downloads/MovixTV/Services/APIService.swift)
- **Home view model** – [`HomeViewModel.swift`](file:///C:/Users/boulo/Downloads/MovixTV/ViewModels/HomeViewModel.swift)
- **Home UI** – [`HomeView.swift`](file:///C:/Users/boulo/Downloads/MovixTV/Views/HomeView.swift)
- **Card UI** – [`MovieCardView.swift`](file:///C:/Users/boulo/Downloads/MovixTV/Views/MovieCardView.swift)
- **Detail & player** – [`DetailView.swift`](file:///C:/Users/boulo/Downloads/MovixTV/Views/DetailView.swift)
- **Glass helper** – [`VisualEffectBlur.swift`](file:///C:/Users/boulo/Downloads/MovixTV/Extensions/VisualEffectBlur.swift)
- **App entry** – [`App.swift`](file:///C:/Users/boulo/Downloads/MovixTV/App.swift)
- **Design assets** – `C:\Users\boulo\Downloads\Distin\LiquidGlassMockups`

If you need any additional screens (search, categories, user profile) or deeper integration with the existing Android logic, just let me know and I’ll add the corresponding SwiftUI views and view‑models.
