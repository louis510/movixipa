import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    private let gridItem = GridItem(.fixed(380), spacing: 30)
    
    @FocusState private var focusedMovieId: String?

    var body: some View {
        ZStack {
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

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [gridItem], spacing: 40) {
                    ForEach(viewModel.movies) { movie in
                        MovieItemView(movie: movie, viewModel: viewModel, focusedMovieId: $focusedMovieId)
                    }
                }
                .padding(.horizontal, 80)
                .padding(.vertical, 40)
            }
        }
        .onAppear { viewModel.loadMovies() }
    }
}

struct MovieItemView: View {
    let movie: Movie
    @ObservedObject var viewModel: HomeViewModel
    var focusedMovieId: FocusState<String?>.Binding

    var body: some View {
        let isFocused = viewModel.focusedMovie?.id == movie.id
        MovieCardView(movie: movie, isFocused: isFocused)
            .focusable(true)
            .focused(focusedMovieId, equals: movie.id)
            .onChange(of: focusedMovieId.wrappedValue) { newId in
                if newId == movie.id {
                    viewModel.focusedMovie = movie
                }
            }
    }
}