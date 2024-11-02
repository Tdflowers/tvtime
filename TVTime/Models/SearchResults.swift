//
//  SearchResults.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 1/2/21.
//

import Foundation

struct MovieSearchResults {
    
    let movies: [Movie]
    let totalPages: Double
    let totalResults: Double
    let page: Int64
}

extension MovieSearchResults: Decodable {

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(MovieSearchResults.self, from: data) else { return nil }
        self = me
    }
}

class TVSearchResults: Decodable, ObservableObject, Identifiable {
    
    @Published var shows: [TVSeries]
    var totalPages: Double
    var totalResults: Double
    var page: Int64
    
    enum CodingKeys: String, CodingKey {
        case page
        case shows = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int64.self, forKey: .page)
        self.shows = try container.decode([TVSeries].self, forKey: .shows)
        self.totalPages = try container.decode(Double.self, forKey: .totalPages)
        self.totalResults = try container.decode(Double.self, forKey: .totalResults)
    }
    
    init (shows: [TVSeries], totalPages: Double, totalResults: Double, page: Int64) {
        self.shows = shows
        self.totalPages = totalPages
        self.totalResults = totalResults
        self.page = page
    }
    
    func updateState(with state: TVSearchResults) {
        self.shows = state.shows
        self.totalPages = state.totalPages
        self.totalResults = state.totalResults
        self.page = state.page
    }
}
