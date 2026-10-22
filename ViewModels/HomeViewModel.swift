import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var focusedMovie: Movie?
    
    private var cancellables = Set<AnyCancellable>()
    
    func loadMovies() {
        APIService.shared.fetchHomeMovies()
            .sink { completion in
                if case let .failure(error) = completion {
                    print("❗️ Failed to fetch home movies: \(error)")
                }
            } receiveValue: { [weak self] list in
                self?.movies = list
                self?.focusedMovie = list.first
            }
            .store(in: &cancellables)
    }
}
