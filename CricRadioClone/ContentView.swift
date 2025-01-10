//
//  ContentView.swift
//  CricRadioClone
//
//  Created by Dhairya bhardwaj on 08/01/25.
//


import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = MatchViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let scorecard = viewModel.miniScorecard {
                    MiniScorecardView(scorecard: scorecard)
                } else {
                    LoadingView(text: "Loading scorecard...")
                }

                if let venueInfo = viewModel.venueInfo {
                    VenueInfoView(venueInfo: venueInfo)
                } else {
                    LoadingView(text: "Loading venue info...")
                }

                if let error = viewModel.errorMessage {
                    ErrorView(error: error)
                }
            }
            .padding()
        }
        .background(Color.black)
        .onAppear {
            viewModel.fetchMatchData()
        }
    }
}

struct LoadingView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundColor(.white)
            .padding()
    }
}

struct ErrorView: View {
    let error: String
    
    var body: some View {
        Text(error)
            .foregroundColor(.red)
            .padding()
    }
}

struct MiniScorecardView: View {
    let scorecard: MiniScorecard

    var body: some View {
        VStack {
            HStack {
                TeamView(team: scorecard.teams.a)
                Spacer()
                CommentaryView(commentary: scorecard.lastCommentary.primaryText)
                Spacer()
                TeamView(team: scorecard.teams.b)
            }
            Divider().background(Color.white)
            MatchDetailsView(runRate: scorecard.now.runRate, announcement: scorecard.announcement1)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct TeamView: View {
    let team: MiniScorecard.Teams.Team
    
    var body: some View {
        VStack(alignment: .center, spacing: 4) {
            HStack {
                if let iconURL = URL(string: team.logo) {
                    AsyncImage(url: iconURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    } placeholder: {
                        ProgressView()
                    }
                } else {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.yellow)
                }
                Text(team.shortName)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
            }
            if let score = team.score1 {
                Text("\(score.runs)/\(score.wickets)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                Text(score.overs ?? "")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
    }
}

struct CommentaryView: View {
    let commentary: String
    
    var body: some View {
        VStack {
            Text(commentary)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
        }
    }
}

struct MatchDetailsView: View {
    let runRate: String
    let announcement: String
    
    var body: some View {
        HStack {
            Text("CRR : \(runRate)")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(announcement)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}


struct VenueInfoView: View {
    let venueInfo: VenueInfo

    var body: some View {
        VStack(alignment: .leading) {
            
            // Display Venue Photo
            DisplayImageView(urlString: venueInfo.venueDetails.photo, width: 350)
            
            // Venue Details
            VenueDetailsView(venueDetails: venueInfo.venueDetails, season: venueInfo.season, startDate: venueInfo.startDate)

            // Toss Details
            TossDetailsView(tossDetails: venueInfo.toss)

            // Umpire Details
            UmpireDetailsView(umpireInfo: venueInfo)

            // Weather Info
            WeatherInfoView(weather: venueInfo.weather)

            // Venue Stats
            VenueStatsView(venueStats: venueInfo.venueStats)
        }
        .padding()
        .background(Color.black)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct DisplayImageView: View {
    let urlString: String
    let width: CGFloat

    var body: some View {
        if let iconURL = URL(string: urlString) {
            AsyncImage(url: iconURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: width)
                    .clipped()
                    .cornerRadius(10)
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
        } else {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.yellow)
        }
    }
}

struct VenueDetailsView: View {
    let venueDetails: VenueInfo.VenueDetails
    let season: VenueInfo.Season
    let startDate: VenueInfo.StartDate
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(venueDetails.knownAs)
                .font(.headline)
                .foregroundColor(.blue)
            Spacer()
            Text(season.name)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(startDate.str)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct TossDetailsView: View {
    let tossDetails: VenueInfo.Toss
    
    var body: some View {
        Text(tossDetails.str)
            .font(.body)
            .foregroundColor(.yellow)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }
}

struct UmpireDetailsView: View {
    let umpireInfo: VenueInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Umpire")
                .foregroundColor(.white)
                .padding(.leading, 10)
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Umpire")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Text("Umpire")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                }
                HStack {
                    Text(umpireInfo.firstUmpire)
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(umpireInfo.secondUmpire)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Divider().background(Color.white)
                HStack {
                    Text("Third/TV Umpire")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    Text("Referee")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                }
                HStack {
                    Text("\(umpireInfo.thirdUmpire)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    Spacer()
                    Text("\(umpireInfo.matchReferee)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

struct WeatherInfoView: View {
    let weather: VenueInfo.Weather
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Weather")
                .foregroundColor(.white)
            
            VStack {
                HStack {
                    if let iconURL = URL(string: weather.condition.icon) {
                        AsyncImage(url: iconURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.yellow)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(weather.location)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text(String(format: "%.1f°C", weather.tempC))
                            .font(.title2)
                            .foregroundColor(.yellow)

                        Text(weather.condition.text)
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("Last Updated\n\(weather.lastUpdated)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
        }
    }
}

struct VenueStatsView: View {
    let venueStats: VenueInfo.VenueStats
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Venue Stats")
                .foregroundColor(.white)
            
            VStack(spacing: 8) {
                VenueStatsSectionView(venueStats: venueStats)
                
                HStack {
                    Spacer()
                    Text("1st Inn")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)
                    Spacer()
                    Text("2nd Inn")
                        .font(.caption)
                        .bold()
                        .foregroundColor(.gray)
                }
                Divider().background(Color.white)
                
                BattingStatsView(battingFirst: venueStats.battingFirst, battingSecond: venueStats.battingSecond)
            }
            .padding()
            .background(Color.black.opacity(0.2))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
    }
}

struct VenueStatsSectionView: View {
    let venueStats: VenueInfo.VenueStats
    
    var body: some View {
        VStack(spacing: 4) {
            VenueStatRow(title: "Matches Played", value: "\(venueStats.matchesPlayed)")
            Divider().background(Color.white)
            VenueStatRow(title: "Lowest Defended", value: "\(venueStats.lowestDefended)")
            Divider().background(Color.white)
            VenueStatRow(title: "Highest Chased", value: "\(venueStats.highestChased)")
            Divider().background(Color.white)
            VenueStatRow(title: "Win Bat First", value: "\(venueStats.batFirstWins)")
            Divider().background(Color.white)
            VenueStatRow(title: "Win Ball First", value: "\(venueStats.ballFirstWins)")
        }
    }
}

struct BattingStatsView: View {
    let battingFirst: VenueInfo.VenueStats.Batting
    let battingSecond: VenueInfo.VenueStats.Batting
    
    var body: some View {
        VStack(spacing: 4) {
            VenueStatRow(title: "Avg Score", value: "\(battingFirst.averageScore)", secondValue: "\(battingSecond.averageScore)")
            Divider().background(Color.white)
            VenueStatRow(title: "Highest Score", value: "\(battingFirst.highestScore)", secondValue: "\(battingSecond.highestScore)")
            Divider().background(Color.white)
            VenueStatRow(title: "Lowest Score", value: "\(battingFirst.lowestScore)", secondValue: "\(battingSecond.lowestScore)")
            Divider().background(Color.white)
            VenueStatRow(title: "Pace Wickets", value: "\(battingFirst.paceWickets)", secondValue: "\(battingSecond.paceWickets)")
            Divider().background(Color.white)
            VenueStatRow(title: "Spin Wickets", value: "\(battingFirst.spinWickets)", secondValue: "\(battingSecond.spinWickets)")
        }
    }
}

struct VenueStatRow: View {
    let title: String
    let value: String
    var secondValue: String? = nil

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .foregroundColor(.white)
            if let secondValue = secondValue {
                Spacer()
                Text(secondValue)
                    .foregroundColor(.white)
            }
        }
    }
}


#Preview {
    ContentView()
}
