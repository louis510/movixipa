import Foundation
import Combine

/// Central networking service for the Movix tvOS app.
final class APIService {
    // MARK: - Singleton
    static let shared = APIService()
    private init() {}

    // Base URL of the Movix backend. Replace with the actual remote instance.
    private let baseURL = URL(string: "https://your-movix-instance.com/api/")!

    // MARK: - Public API
    /// Retrieves the list of movies displayed on the home screen.
    /// - Returns: Publisher emitting an array of ``Movie`` or an ``Error``.
    func fetchHomeMovies() -> AnyPublisher<[Movie], Error> {
        let endpoint = baseURL.appendingPathComponent("movies/home")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        // Example: request.addValue("Bearer <token>", forHTTPHeaderField: "Authorization")
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse,
                      200..<300 ~= http.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Movie].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
