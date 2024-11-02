//
//  APIConnect.swift
//  BingeCheck
//
//  Created by Tyler Flowers on 3/10/19.
//  Copyright © 2019 Tyler Flowers. All rights reserved.
//

import SwiftUI
import Foundation

public enum NetworkError: Error, LocalizedError {
    
    case missingRequiredFields(String)
    
    case invalidParameters(operation: String, parameters: [Any])
    
    case badRequest
    
    case unauthorized
    
    case paymentRequired
    
    case forbidden
    
    case notFound
    
    case requestEntityTooLarge

    case unprocessableEntity
    
    case http(httpResponse: HTTPURLResponse, data: Data)
    
    case invalidResponse(Data)
    
    case deleteOperationFailed(String)
    
    case network(URLError)
    
    case unknown(Error?)

}

let APIBASEURL = "https://api.themoviedb.org/3"
let APIIMAGEBASEURL = "https://image.tmdb.org/t/p/"

class APIConnect: ObservableObject {
    
    // MARK: - Properties
    @Published var popularTVShows: TVSearchResults?

   let baseURL: String
   // Initialization

    init(baseURL: String) {
       self.baseURL = baseURL
   }

    //MARK: - Movie Calls
    func getPopularMovies(languge: String, region: String, completion: @escaping (PopularMovieResults) -> ()) {
        
        let urlString = APIBASEURL + "/movie/popular"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: languge), URLQueryItem(name: "region", value: region)]
        let request = URLRequest(url: urlComponents!.url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            if let data = responseData, let _ = String(data: data, encoding: .utf8) {
                do {
                    let moviesResults = try JSONDecoder().decode(PopularMovieResults.self, from: data)
                    completion(moviesResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getNowPlayingMovies(languge: String, region: String, completion: @escaping (NowPlayingMovies) -> ()) {
        
        let urlString = APIBASEURL + "/movie/now_playing"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: languge), URLQueryItem(name: "region", value: region)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            if let data = responseData, let _ = String(data: data, encoding: .utf8) {
                do {
                    let moviesResults = try JSONDecoder().decode(NowPlayingMovies.self, from: data)
                    completion(moviesResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getUpcomingMovies(languge: String, region: String, completion: @escaping (UpcomingMovies) -> ()) {
        
        let urlString = APIBASEURL + "/movie/upcoming"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: languge), URLQueryItem(name: "region", value: region)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            if let data = responseData, let _ = String(data: data, encoding: .utf8) {
                do {
                    let moviesResults = try JSONDecoder().decode(UpcomingMovies.self, from: data)
                    completion(moviesResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getMovieSearchResults(languge: String, region: String, query: String, page: String,completion: @escaping (MovieSearchResults) -> ()) {
        
        let urlString = APIBASEURL + "/search/movie"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: languge), URLQueryItem(name: "region", value: region), URLQueryItem(name: "page", value: page), URLQueryItem(name: "query", value: query)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            if let data = responseData, let _ = String(data: data, encoding: .utf8) {
                do {
                    let movieSearchResults = try JSONDecoder().decode(MovieSearchResults.self, from: data)
                    completion(movieSearchResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getMovieDetailsFor(id: Int64, completion: @escaping (Movie) -> ()) {
        let idString = String(id)
        let urlString = APIBASEURL + "/movie/" + idString
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            if let data = responseData, let _ = String(data: data, encoding: .utf8) {
                do {
                    let moviesResults = try JSONDecoder().decode(Movie.self, from: data)
                    completion(moviesResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
    
    func getMovieCreditsFor(id: Int64, completion: @escaping (Credits) -> ()) {
        let idString = String(id)
        
        let urlString = APIBASEURL + "/movie/" + idString + "/credits"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else {
                return
            }
            
            if let data = responseData, let _ = String(data: data, encoding: .utf8) {
                do {
                    let moviesResults = try JSONDecoder().decode(Credits.self, from: data)
                    completion(moviesResults)
                } catch let error {
                    print(error as Any)
                }
            } else {
                print("no readable data received in response")
            }
        }
        task.resume()
    }
 
    //MARK: -- TV API Calls
    
    func getTVPopular(language: String = "en-US", page: String = "1") async throws {
        let urlString = APIBASEURL + "/tv/popular"
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: language), URLQueryItem(name: "page", value: page)]
        guard let url = urlComponents?.url else { throw NetworkError.badRequest}
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        Task { @MainActor in
            popularTVShows = try JSONDecoder().decode(TVSearchResults.self, from: data)
        }
    }
    
    func getTVAiringToday(language: String, page: String) async throws -> TVSearchResults {
        let urlString = APIBASEURL + "/tv/airing_today"
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: language), URLQueryItem(name: "page", value: page)]
        guard let url = urlComponents?.url else { throw NetworkError.badRequest}
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let tvSearchResults = try JSONDecoder().decode(TVSearchResults.self, from: data)
        return tvSearchResults
    }
    
    func getTVSearchResults(language: String, query: String, page: String) async throws -> TVSearchResults {
        let urlString = APIBASEURL + "/search/tv"
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY), URLQueryItem(name: "languge", value: language), URLQueryItem(name: "page", value: page), URLQueryItem(name: "query", value: query)]
        guard let url = urlComponents?.url else { throw NetworkError.badRequest}
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let tvSearchResults = try JSONDecoder().decode(TVSearchResults.self, from: data)
        return tvSearchResults
    }
    
    func getTVSeriesEpisodeGroups(show:Int64) async throws -> [TVEpisodeGroupsResult] {
        let urlString = APIBASEURL + "/tv/" + String(show) + "/episode_groups"
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let episodeGroupResults = try JSONDecoder().decode(TVEpisodeGroups.self, from: data)
        return episodeGroupResults.results
    }
    
    func getTVSeriesEpisodeGroupDetails(showId:String) async throws -> TVEpisodeGroupDetails {
        let urlString = APIBASEURL + "/tv/episode_group/" + showId
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let episodeGroupResults = try JSONDecoder().decode(TVEpisodeGroupDetails.self, from: data)
        return episodeGroupResults
    }
    
    func getTVSeriesDetailsFor(show: Int64) async throws -> TVSeries {
        let showString = String(show)
        let urlString = APIBASEURL + "/tv/" + showString
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let tvSeriesResults = try JSONDecoder().decode(TVSeries.self, from: data)
        return tvSeriesResults
    }
    
    func getTVSeriesSeasonDetailsFor(show: Int64, season: Int64) async throws -> TVSeason {
        let showString = String(show)
        let seasonString = String(season)
        let urlString = APIBASEURL + "/tv/" + showString + "/season/" + seasonString
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: APIKEY)]
        let request = URLRequest(url: urlComponents!.url!)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let tvSeasonResults = try JSONDecoder().decode(TVSeason.self, from: data)
        return tvSeasonResults
    }
    
    //MARK: - Helper Funcs
    
    /// Get All Episodes for Series
    /// - Parameter showId: Int64 of series for MovieDB
    /// - Returns: returns sorted array of TVSeason
    func getAllEpisodeInfoForShowId(_ showId:Int64) async throws -> (TVSeries,[TVSeason]) {
        do {
            let tvSeriesDetails = try await APIConnect(baseURL: APIBASEURL).getTVSeriesDetailsFor(show: showId)
            var seasons = try await withThrowingTaskGroup(of: TVSeason.self, returning: [TVSeason].self) { taskGroup in
                for seasonNumber in (1...Int64(tvSeriesDetails.numberOfSeasons!)) {
                    taskGroup.addTask { try await APIConnect(baseURL: APIBASEURL).getTVSeriesSeasonDetailsFor(show: showId, season: seasonNumber) }
                }
                return try await taskGroup.reduce(into: [TVSeason]()) { partialResult, name in
                    if let episodes = name.episodes {
                        if !episodes.isEmpty {
                            partialResult.append(name)
                        }
                    }
                }
            }
            seasons.sort(by: {$0.seasonNumber ?? 0 < $1.seasonNumber ?? 0 })
            return (tvSeriesDetails, seasons)
        } catch {
           throw error
        }
    }
}
