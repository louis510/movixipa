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
                    .background(VisualEffectBlur(blurStyle: .systemMaterialDark, intensity: 0.4))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { player?.pause() }
    }

    private func startPlayback() {
        // The backend provides a streaming URL – adapt the path as needed.
        guard let streamURL = URL(string: "https://your-movix-instance.com/stream/\(movie.id)") else { return }
        player = AVPlayer(url: streamURL)
        let vc = AVPlayerViewController()
        vc.player = player
        vc.showsPlaybackControls = true
        // Present the AVPlayerViewController using UIKit bridge.
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = windowScene.windows.first?.rootViewController {
            root.present(vc, animated: true) {
                player?.play()
            }
        }
    }
}
