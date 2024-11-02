//
//  TVSeries.swift
//  MovieCollector
//
//  Created by Tyler Flowers on 5/13/22.
//

import Foundation

struct Genre: Equatable, Hashable, Identifiable {
    let id : Int64?
    let name: String?
}

extension Genre : Codable {
    enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(Genre.self, from: data) else { return nil }
            self = me
    }
}

struct TVNetwork : Equatable, Hashable, Identifiable {
    let id: Int64?
    let name:String?
    let logoPath:String?
    let originCountry:String?
}

extension TVNetwork : Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
    
    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(TVNetwork.self, from: data) else { return nil }
            self = me
    }
}

struct TVSeries : Equatable, Hashable, Identifiable {
    static func == (lhs: TVSeries, rhs: TVSeries) -> Bool {
        return false
    }
    

    let id: Int64
    let name: String
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let adult: Bool?
    let genres:[Genre]?
    let popularity:Float?
    let voteCount:Int64?
    let voteAverage:Float?
    let backdropPath:String?
    let originalName:String?
    let originalLanguage:String?
    let runtime:[Int64]?
    let createdBy:[Cast]?
    let firstAirDate:String?
    let homepage:String?
    let inProduction:Bool?
    let lastAirDate:String?
    let nextEpisodeToAir:TVEpisode?
    let lastEpisodeToAir:TVEpisode?
    let networks:[TVNetwork]?
    let numberOfEpisodes:Int64?
    let numberOfSeasons:Double?
    let originCountry:[String]?
    let productionCompanies:[ProductionCompany]?
    let productionCountries:[ProductionCountry]?
    let seasons:[TVSeason]?
    let spokenLanguages:[SpokenLanguage]?
    let status: String?
    let tagline: String?
    let type:String?
}

extension TVSeries: Codable {

    enum CodingKeys: String, CodingKey {
        case id, name, overview, adult, popularity, homepage, networks, seasons, status, tagline, type
        case runtime = "episode_run_time"
        case posterPath  = "poster_path"
        case releaseDate = "release_date"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case genres = "genres"
        case backdropPath = "backdrop_path"
        case voteCount = "vote_count"
        case voteAverage = "vote_average"
        case createdBy = "created_by"
        case firstAirDate = "first_air_date"
        case lastAirDate = "last_air_date"
        case inProduction = "in_production"
        case lastEpisodeToAir = "last_episode_to_air"
        case nextEpisodeToAir = "next_episode_to_air"
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
        
        
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(TVSeries.self, from: data) else { return nil }
            self = me
    }
}

struct TVSeason : Equatable, Hashable, Identifiable {
    let airDate:String?
    let episodes:[TVEpisode]?
    let episodeCount: Int64?
    let id: Int64?
    let name:String?
    let overview:String?
    let posterPath:String?
    let seasonNumber:Int64?
}

extension TVSeason : Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case airDate = "air_date"
        case episodes = "episodes"
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
        case episodeCount = "episode_count"
    }
    
    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(TVSeason.self, from: data) else { return nil }
            self = me
    }
}

struct TVEpisode : Equatable, Hashable, Identifiable {
    static func == (lhs: TVEpisode, rhs: TVEpisode) -> Bool {
        return true
    }
    
    let airDate:Date?
    let crew:[Crew]?
    let guestStars:[Cast]?
    let episodeNumber:Int64?
    let productionCode: String?
    let id: Int64?
    let name:String?
    let overview:String?
    let stillPath:String?
    let seasonNumber:Int64?
    let runtime:Int64?
    let voteAverage:Float?
    let voteCount:Int64?
    
    var averagedRuntime:Int?

}

extension TVEpisode : Codable {
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview, crew, runtime
        case guestStars = "guest_stars"
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case stillPath = "still_path"
        case seasonNumber = "season_number"
        case productionCode = "production_code"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(TVEpisode.self, from: data) else { return nil }
            self = me
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try? container.decode(Int64.self, forKey: .id)
        name = try? container.decode(String.self, forKey: .name)
        let airDateString = try? container.decode(String.self, forKey: .airDate)
        let dateFormatter = DateFormatter.yyyyMMdd
        if let airDataStringVerified = airDateString, let airDateConverted = dateFormatter.date(from: airDataStringVerified) {
            airDate = airDateConverted
        } else {
            airDate = nil
        }
        crew = try? container.decode([Crew].self, forKey: .crew)
        guestStars = try? container.decode([Cast].self, forKey: .guestStars)
        episodeNumber = try? container.decode(Int64.self, forKey: .episodeNumber)
        productionCode = try? container.decode(String.self, forKey: .productionCode)
        overview = try? container.decode(String.self, forKey: .overview)
        stillPath = try? container.decode(String.self, forKey: .stillPath)
        seasonNumber = try? container.decode(Int64.self, forKey: .seasonNumber)
        runtime = try? container.decode(Int64.self, forKey: .runtime)
        voteCount = try? container.decode(Int64.self, forKey: .voteCount)
        voteAverage = try? container.decode(Float.self, forKey: .voteAverage)
    }
    
}

struct TVEpisodeGroupDetails: Codable {
    let description: String
    let episode_count: Double
    let group_count: Double
    var groups: [TVEpisodeGroupSeasons]
    
    struct TVEpisodeGroupSeasons: Codable {
        let id: String
        let name: String
        let order: Double
        let episodes: [TVEpisodeGroupsEpisodes]
        
        struct TVEpisodeGroupsEpisodes: Codable {
            let air_date: String //This is a date in format 2011-04-17
            let episode_number: Double
            let episode_type: String
            let id: Double
            let name: String
            let overview: String
            let production_code: String
            let runtime: Int64?
            let season_number: Double
            let show_id: Double
            let still_path: String?
            let vote_average: Double
            let vote_count: Double
            let order: Double
        }
                
    }
    
    let id: String
    let name: String
    let network: TVEpisodeGroupNetwork?
    let type: Double
}

struct TVEpisodeGroupNetwork : Codable {
    let id: Int64
    let logoPath: String
    let name: String
    let originCountry: String
}
  
extension TVEpisodeGroupNetwork {
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case originCountry = "origin_country"
        case name
    }
    
    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(TVEpisodeGroupNetwork.self, from: data) else { return nil }
            self = me
    }
}

struct TVEpisodeGroups: Codable {
    let results: [TVEpisodeGroupsResult]
    let id: Int
}

struct TVEpisodeGroupsResult: Codable {
    let description: String
    let episodeCount, groupCount: Int
    let id, name: String
    let network: TVEpisodeGroupNetwork?
    let type: Int

    enum CodingKeys: String, CodingKey {
        case description
        case episodeCount = "episode_count"
        case groupCount = "group_count"
        case id, name, network, type
    }
}
