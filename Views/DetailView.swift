import SwiftUI
import AVKit

struct DetailView: View {
    let movie: Movie
    @State private var player: AVPlayer?

    var body: some View {
        ZStack {
            // Background – blurred backdrop
            if let backdrop = movie.backdropURL {
                AsyncImage(url: backdrop) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .blur(radius: 30)
                        .ignoresSafeArea()
                } placeholder: {
                    Color.black.opacity(0.6).ignoresSafeArea()
                }
            } else {
                Color.black.ignoresSafeArea()
            }

            VStack(spacing: 30) {
                // Poster
                AsyncImage(url: movie.posterURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 380)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .frame(width: 380, height: 570)
                }

                // Title & Overview
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title).bold().foregroundColor(.white)
                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(.horizontal, 40)

                // Play button – launches native AVPlayer
                Button(action: startPlayback) {
                    HStack {
                        Image(systemName: "play.circle.fill")
                            .font(.system(size: 50))
                        Text("Play")
                            .font(.title2).bold()
                    }
                    .padding()
                    .background(VisualEffectBlur(blurStyle: .dark, intensity: 0.4))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onDisappear { player?.pause() }
    }

    private func startPlayback() {
        guard let streamURL = URL(string: "https://your-movix-instance.com/stream/\(movie.id)") else { return }
        player = AVPlayer(url: streamURL)
        let vc = AVPlayerViewController()
        vc.player = player
        vc.showsPlaybackControls = true
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            root.present(vc, animated: true) {
                player?.play()
            }
        }
    }
}
```[cite: 2]

---

### 2. `Views/MovieCardView.swift` (Corrigé)
*Remplacement de `.systemMaterialDark` par `.dark` pour l'effet liquid-glass.*

```swift
import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let isFocused: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Poster image
            AsyncImage(url: movie.posterURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 320, height: 460)
                    .clipped()
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(width: 320, height: 460)
            }

            // Liquid‑glass overlay
            VisualEffectBlur(blurStyle: .dark, intensity: isFocused ? 0.45 : 0.3)
                .frame(height: 120)
                .overlay(
                    VStack(alignment: .leading, spacing: 4) {
                        Text(movie.title)
                            .font(.title3).bold()
                            .foregroundColor(.white)
                        Text(movie.overview)
                            .font(.caption2)
                            .lineLimit(2)
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8),
                    alignment: .bottomLeading
                )
        }
        .cornerRadius(12)
        .scaleEffect(isFocused ? 1.08 : 1.0)
        .animation(.easeOut(duration: 0.18), value: isFocused)
        .shadow(color: .black.opacity(isFocused ? 0.6 : 0.35), radius: isFocused ? 18 : 10, x: 0, y: 3)
    }
}
```[cite: 3]

---

### Comment tout valider ?

Une fois ces modifications enregistrées dans tes fichiers sous Windows, exécute ces commandes dans ton PowerShell :

```powershell
cd C:\Users\boulo\Downloads\MovixTV
git add .
git commit -m "Fix final UIBlurEffect styles for tvOS compatibility"
git push origin main