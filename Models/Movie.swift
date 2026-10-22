import Foundation

/// Represents a movie in the Movix catalogue.
/// Conforms to ``Identifiable`` for SwiftUI lists and ``Decodable`` for JSON parsing.
struct Movie: Identifiable, Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let backdropPath: String

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }

    /// Full URL for the poster image. Adjust the base URL if your backend uses a different CDN.
    var posterURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    /// Full URL for the backdrop image used in detail screens.
    var backdropURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)")
    }
}
