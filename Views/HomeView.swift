import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    private let gridItem = GridItem(.fixed(380), spacing: 30)

    var body: some View {
        ZStack {
            // Background – blurred backdrop of the currently focused movie
            if let backdrop = viewModel.focusedMovie?.backdropURL {
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

            // Carousel of movie cards
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [gridItem], spacing: 40) {
                    ForEach(viewModel.movies) { movie in
                        MovieCardView(movie: movie, isFocused: viewModel.focusedMovie?.id == movie.id)
                            .focusable(true)
                            .onFocusChange { focused in
                                if focused { viewModel.focusedMovie = movie }
                            }
                    }
                }
                .padding(.horizontal, 80)
                .padding(.vertical, 40)
            }
        }
        .onAppear { viewModel.loadMovies() }
    }
}
