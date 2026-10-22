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