//
//  MovieViewModel.swift
//  Architectures
//
//  Created by Fabijan Bajo on 25/05/2017.
//
//
/*
    MVVM ViewModels should not access UIKit
*/

import Foundation


final class MovieViewModel: ViewModelInterface {
    
    
    // MARK: - Properties
    
    fileprivate var movies = [Movie]() { didSet { modelUpdate?() } }
    var count: Int { return movies.count }
    struct PresentableInstance: Transportable {
        let title: String
        let thumbnailURL: URL
        let fullSizeURL: URL
        let ratingText: String
        let releaseDateText: String
    }
    private let releaseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter
    }()
    
    
    // MARK: - Binds

    
    typealias modelUpdateClosure = () -> Void
    typealias showDetailClosure = (URL, String) -> Void
    
    // Bind model updates and collectionview reload
    private var modelUpdate: modelUpdateClosure?
    func bindViewReload(with modelUpdate: @escaping () -> Void) {
        self.modelUpdate = modelUpdate
    }
    func fetchNewModelObjects() {
        DataManager.shared.fetchNewTmdbObjects(withType: .movie) { (result) in
            switch result {
            case let .success(transportables):
                self.movies = transportables as! [Movie]
            case let .failure(error):
                print(error)
            }
        }
    }

    
    // Bind collectionViewDidTap and detlaiVC presentation
    private var showDetail: showDetailClosure?
    func bindPresentation(with showDetail: @escaping (URL, String) -> Void) {
        self.showDetail = showDetail
    }
    func showDetail(at indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        let presentable = presentableInstance(from: movie) as! PresentableInstance
        showDetail?(presentable.fullSizeURL, presentable.title)
    }
    
    
    // MARK: - Helpers
    
    // Subscript: viewModel[i] -> PresentableInstance
    subscript (index: Int) -> Transportable { return presentableInstance(from: movies[index]) }
    func presentableInstance(from model: Transportable) -> Transportable {
        let movie = model as! Movie
        let thumbnailURL = TmdbAPI.tmdbImageURL(forSize: .thumb, path: movie.posterPath)
        let fullSizeURL = TmdbAPI.tmdbImageURL(forSize: .full, path: movie.posterPath)
        let ratingText = String(format: "%.1f", movie.averageRating)
        let dateObject = releaseDateFormatter.date(from: movie.releaseDate)
        let releaseDateText = releaseDateFormatter.string(from: dateObject!)
        return PresentableInstance(title: movie.title, thumbnailURL: thumbnailURL, fullSizeURL: fullSizeURL, ratingText: ratingText, releaseDateText: releaseDateText)
    }
}


// MARK: - CollectionViewConfigurable

extension MovieViewModel: CollectionViewConfigurable {
    
    // MARK: - Properties
    
    // Required
    var cellID: String { return "MovieCell" }
    var widthDivisor: Double { return 2.0 }
    var heightDivisor: Double { return 2.5 }
    
    // Optional
    var interItemSpacing: Double? { return 1 }
    var lineSpacing: Double? { return 1 }
    var bottomInset: Double? { return 49 }
}

