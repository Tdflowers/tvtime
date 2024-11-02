//
//  ContentView.swift
//  TVTime
//
//  Created by Tyler Flowers on 6/14/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var movieDb: APIConnect

    var body: some View {
        TabView {
            Group {
                PopularShows()
                    .tabItem {
                        Label("Popular", systemImage: "film")
                    }
                    .environmentObject(movieDb)
                NavigationStack {
                    let searchobj = TVSearchResults(shows: [], totalPages: 0, totalResults: 0, page: 0)
                    Search(searchReturn: searchobj)
                }
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass.circle")
                    }
                    .environmentObject(movieDb)
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.none, for: .tabBar)
        }
    }
}

struct PopularShows: View {
    @EnvironmentObject var movieDb: APIConnect
    let columnLayout = Array(repeating: GridItem(alignment: .top), count: 3)
    
    @State var isShowingPopover: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    LazyVGrid(columns: columnLayout) {
                        if let shows = movieDb.popularTVShows?.shows {
                            ForEach(shows, id: \.id) { show in
                                NavigationLink(value: show) {
                                    PosterView(showDetails: show)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                            
                    }
                    .navigationDestination(for: TVSeries.self) { show in
                        DetailView(show: show)
                            .environmentObject(movieDb)
                    }
                    .task {
                        try? await movieDb.getTVPopular()
                    }
                }
            }
            .navigationTitle("Popular TV Shows")
            .toolbar {
                Button {
                    isShowingPopover = true
               } label: {
                   Image(systemName: "questionmark.circle")
               }
            }
            .popover(isPresented: $isShowingPopover) {
                VStack {
                    Text("Credits")
                        .font(.headline)
                        .padding()
                    Text("This product uses the TMDB API but is not endorsed or certified by TMDB.")
                        .font(.body)
                        .padding()
                    Image("tmdb_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
                    Spacer()
                }
            }
        }
    }
}

struct Search: View {
    @EnvironmentObject var movieDb: APIConnect
    let columnLayout = Array(repeating: GridItem(alignment: .top), count: 3)
    
    @State private var searchText: String = ""
    @ObservedObject var searchReturn: TVSearchResults
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columnLayout) {
                    ForEach(searchReturn.shows, id: \.id) { show in
                        NavigationLink(value: show) {
                            PosterView(showDetails: show)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
                .navigationDestination(for: TVSeries.self) { show in
                    DetailView(show: show)
                        .environmentObject(movieDb)
                }
            }
        }
        .navigationTitle("Search")
        .searchable(text: $searchText, placement: .navigationBarDrawer, prompt: "Start Typing...")
        .onChange(of: searchText, runSearch)
        .onSubmit(of: .search, runSearch)
    }
    
    func runSearch() {
        Task {
            do {
                let localSearchReturn = try await movieDb.getTVSearchResults(language: "en-US", query: searchText, page: "1")
                searchReturn.updateState(with: localSearchReturn)
            } catch {
                print(error)
            }
        }
    }
}

struct DetailView: View {
    @EnvironmentObject var movieDb: APIConnect
    
    @State var tvSeries: TVSeries?
    @State var tvSeasons: [TVSeason]?
    @State var averageLengthString: String?
    @State var averageLengthInt: Int?

    var show: TVSeries
    var body: some View {
                List {
                    Section() {
                        VStack(alignment: .leading) {
                            HStack(alignment: .top) {
                                PosterView(showDetails: show, hideTitle: true)
                                VStack(alignment: .leading) {
//                                    //Title + year
                                    if let firstAirDate = show.firstAirDate {
                                        Text("\(show.name) (\(firstAirDate.prefix(4)))")
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(3)
                                            .foregroundStyle(.primary)
                                            .font(.title2)
                                    } else {
                                        Text("\(show.name)")
                                            .multilineTextAlignment(.leading)
                                            .lineLimit(3)
                                            .foregroundStyle(.primary)
                                            .font(.title2)
                                    }
                                    
                                    //Airing on
                                    if let networks = tvSeries?.networks {
                                        let networksString = EpisodeTools().generateNetworksString(networks)
                                        Text(networksString)
                                    }
                                    //Averaged total length
                                    if let averageLengthString {
                                        Text(averageLengthString)
                                            .italic()
                                    }
                                }
                            }
                            //Description
                            Text("Overview:")
                                .font(.callout)
                                .bold()
                            if let Description = show.overview {
                                Text(Description)
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.primary)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
                            }
                        }
                            
                            .task {
                                do {
                                    (tvSeries, tvSeasons) = try await movieDb.getAllEpisodeInfoForShowId( show.id)
                                    (averageLengthString, averageLengthInt) = EpisodeTools().generateTimeFrom(tvSeasons: tvSeasons!)
                                } catch {
                                    
                                }
                            }
                        }
                        .listRowSeparator(.hidden)
                            if let tvSeasons {
                                ForEach(tvSeasons) { season in
                                    if let episodes = season.episodes {
                                        let (_, day, hour, minute, _) = EpisodeTools().calculateRuntimeFromEpisodes(episodes, averageRuntime: averageLengthInt ?? 0)
                                    Section (header: Text("\(season.name!) is \(day) \(hour) and \(minute) long")
                                        .font(.headline)){
                                            ForEach(episodes) { episode in
                                                SeasonDetailView(episode: episode)
                                            }
                                    }
                                }
                        
                }
            }
        }
                .listStyle(.plain)
//                .background(Color.black.opacity(0.5))
            .navigationTitle(show.name)
            .navigationBarTitleDisplayMode(.inline)

    }
}

struct SeasonDetailView: View {
    var episode:TVEpisode
    @State private var displayTitle:String = ""
    @State private var displayLength:String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(displayTitle)
                .font(.headline)
            Text(displayLength)
            Text(episode.overview!)
                .font(.caption)
        }
        .task {
            (displayTitle, displayLength) = EpisodeTools().generateTitleAndLengthStringForEpisode(episode)
        }
    }

}

struct PosterView: View {
    var showDetails: TVSeries
    var hideTitle = false
    
    var body: some View {
        VStack {
            let posterUrl = APIIMAGEBASEURL + "w300" + (showDetails.posterPath ?? "")
            AsyncImage(url: URL(string:posterUrl)) {phase in
                
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(5)
                        .frame(maxWidth: 175)
                }  else if phase.error != nil  {
                    VStack {
                        Image("placeholder poster")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 175)
                    }
                    
                } else {
                    ZStack {
                        Image("placeholder poster")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 175)
                        ProgressView()
                    }
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
            if !hideTitle {
                if let firstAirDate = showDetails.firstAirDate {
                    Text("\(showDetails.name) (\(firstAirDate.prefix(4)))")
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .foregroundStyle(.primary)
                } else {
                    Text("\(showDetails.name)")
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .foregroundStyle(.primary)
                }
            }
        }
    }
}
