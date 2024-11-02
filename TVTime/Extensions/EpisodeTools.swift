//
//  EpisodeTools.swift
//  BingeTime
//
//  Created by Tyler Flowers on 7/7/24.
//

import Foundation

class EpisodeTools {
    func calculateRuntimeFromEpisodes(_ episodes: [TVEpisode], averageRuntime:Int = 0) -> (total:Int, days: String, hours: String, minutes: String, average:Int){
        var totalRuntime:Int = 0
        var episodesWithoutRuntimes = 0
        var episodesWithRuntimes = 0
        var averageRuntime = averageRuntime
        
        for episode in episodes {
            if let runtime = episode.runtime, let airDate = episode.airDate {
                if airDate < Date.now {
                    totalRuntime += Int(runtime)
                }
                episodesWithRuntimes += 1
            } else {
                episodesWithoutRuntimes += 1
            }
        }
        if episodesWithRuntimes > 0 {
            averageRuntime = totalRuntime / episodesWithRuntimes
        }
        if episodesWithoutRuntimes > 0 {
            totalRuntime += averageRuntime * episodesWithoutRuntimes
        }
        
        let (daysString, hoursString, minutesString) = calculateLengthFromRuntime(totalRuntime)
        
        return (totalRuntime, daysString, hoursString, minutesString, averageRuntime)
    }
    
    func calculateLengthFromRuntime(_ totalRuntime:Int) -> (days: String, hours: String, minutes: String) {
        let days = (totalRuntime / 1440)
        let hours = (totalRuntime % 1440) / 60
        let minutes = (totalRuntime % 60)
        
        var daysString = ""
        var hoursString = ""
        var minutesString = ""
        
        if days > 0 {
            if days == 1 {
                daysString = String(days) + " day"
            } else {
                daysString = String(days) + " days"
            }
        }
        
        if hours > 0 {
            if hours == 1 {
                hoursString = String(hours) + " hour"
            } else {
                hoursString = String(hours) + " hours"
            }
        }
        
        if minutes > 0 {
            if minutes == 1 {
                minutesString = String(minutes) + " minute"
            } else {
                minutesString = String(minutes) + " minutes"
            }
        }
        
        return (daysString, hoursString, minutesString)
    }
    
    func generateTitleAndLengthStringForEpisode(_ episode: TVEpisode) -> (title: String, length: String) {
        var titleString = ""
        var lengthString = ""
        
        if let airDate = episode.airDate {
            titleString = (episode.name ?? "No Episode Title") + " - " + airDate.formatted(date: .abbreviated, time: .omitted)
            if Date.now <= airDate {
                //Episode has not aired
                lengthString = "Episode has yet to air"
            } else {
                if episode.runtime != nil { // || episode.runtime != 0 {
                    let (runtime, _, hour, minute, _) = EpisodeTools().calculateRuntimeFromEpisodes([episode])
                    var timeString = ""
                    if ((runtime % 1440) / 60 ) > 0 {
                        if minute != "" {
                            timeString =  ("\(hour) and \(minute) long")
                        } else {
                            timeString =  ("\(hour) long")
                        }
                    } else {
                        timeString =  ("\(minute) long")
                    }
                    lengthString = timeString
                } else {
                    lengthString = "No Runtime Found"
                }
                
            }
        } else {
            titleString = episode.name ?? "No Episode Title"
            if let runtime = episode.runtime {
                if runtime != 0 {
                    let (runtime, _, hour, minute, _) = EpisodeTools().calculateRuntimeFromEpisodes([episode])
                    var timeString = ""
                   
                    if ((runtime % 1440) / 60 ) > 0 {
                        if minute != "" {
                            timeString =  ("\(hour) and \(minute) long")
                        } else {
                            timeString =  ("\(hour) long")
                        }
                    } else {
                        timeString =  ("\(minute) long")
                    }
                    lengthString = timeString
                } else {
                    lengthString = "No Airdate or runtime Found"
                }
            } else {
                lengthString = "No Runtime Found"
            }
        }
        return (titleString, lengthString)
    }
    
    
    func generateNetworksString(_ networks: [TVNetwork]) -> String {
            var networksString = "Networks: "
        for network in networks {
                networksString = networksString + network.name! + ", "
        }
        networksString.removeLast(2)
        return networksString
    }
 
    func generateTimeFrom(tvSeasons:[TVSeason]) -> (String, Int){
        
        var episodes:[TVEpisode] = []
        for season in tvSeasons {
            if let unwrappedepisodes = season.episodes {
                for episode in unwrappedepisodes {
                    episodes.append(episode)
                }
            }
        }
        let (total, days, hours, minutes, average) = EpisodeTools().calculateRuntimeFromEpisodes(episodes)
        var returnString = ""
        if total > 0 {
//            self.averageLength = average
            if average == 0 {
                returnString = "Total length of: " + days + " " + hours + " " + minutes
            } else {
                returnString = "Averaged Total length of: " + days + " " + hours + " " + minutes
            }
        } else {
            returnString = "There was an error calculating runtime"
        }
        return (returnString,average)
    }
}
