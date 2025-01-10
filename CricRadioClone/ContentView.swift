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
                    Text("Loading scorecard...")
                        .foregroundColor(.white)
                }

                if let venueInfo = viewModel.venueInfo {
                    VenueInfoView(venueInfo: venueInfo)
                } else {
                    Text("Loading venue info...")
                        .foregroundColor(.white)
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
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

struct MiniScorecardView: View {
    let scorecard: MiniScorecard

    var body: some View {
        VStack() {
            HStack {
                VStack(alignment: .center, spacing: 4) {
                    HStack {
                        if let iconURL = URL(string: scorecard.teams.a.logo) { // Check if the icon is a valid URL
                            AsyncImage(url: iconURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            } placeholder: {
                                ProgressView() // Show a loading indicator while the image loads
                            }
                        } else {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.yellow)
                        }
                        Text(scorecard.teams.a.shortName)
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                    }
                    if let score1 = scorecard.teams.a.score1 {
                        Text("\(score1.runs)/\(score1.wickets)")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.white)
                        Text(score1.overs ?? "")
                            .font(.subheadline)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                VStack {
                    Text("\(scorecard.lastCommentary.primaryText)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                }
                Spacer()
                VStack{
                    HStack {
                        if let iconURL = URL(string: scorecard.teams.b.logo) {
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
                        Text(scorecard.teams.b.shortName)
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                if let score1 = scorecard.teams.b.score1 {
                    Text("\(score1.runs)/\(score1.wickets)")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                    Text(score1.overs ?? "")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
            Divider().background(Color.white)
            HStack{
                Text("CRR : \(scorecard.now.runRate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("\(scorecard.announcement1)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}


struct VenueInfoView: View {
    let venueInfo: VenueInfo

    var body: some View {
        VStack(alignment: .leading) {
            
            if let iconURL = URL(string: venueInfo.venueDetails.photo) {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
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
            

            // Venue Details
            VStack(alignment: .leading) {
                Text("\(venueInfo.venueDetails.knownAs)")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                Text(venueInfo.season.name)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(venueInfo.startDate.str)
                    .font(.subheadline)
                    .foregroundColor(.white)
                Spacer()
            }
            Spacer()
            Text(venueInfo.toss.str) .font(.body) .foregroundColor(.yellow) .padding() .frame(maxWidth: .infinity, alignment: .leading) .background(Color.gray.opacity(0.2)) .cornerRadius(8)
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
            Spacer()
            VStack (alignment: .leading){
                Spacer()
                Spacer()
                Text("Umpire")
                    .foregroundColor(.white)
                    .padding(.leading,10)
            }
            
            
            VStack (alignment: .leading){
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
                        HStack{
                            Text(venueInfo.firstUmpire)
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(venueInfo.secondUmpire)")
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
                            
                            Text("\(venueInfo.thirdUmpire)")
                                .font(.subheadline)
                                .foregroundColor(.white)
                            Spacer()
                            Text("\(venueInfo.matchReferee)")
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
            Spacer()
            Spacer()
            Text("Weather")
                .foregroundColor(.white)

            // Weather Info
            VStack {
                HStack {
                    if let iconURL = URL(string: venueInfo.weather.condition.icon) {
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
                        Text("\(venueInfo.weather.location)")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("\(venueInfo.weather.tempC)°C")
                            .font(.title2)
                            .foregroundColor(.yellow)
                        Text("\(venueInfo.weather.condition.text)")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    Text("Last Updated\n\(venueInfo.weather.lastUpdated)")
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

            // Venue Stats
            Spacer()
            Spacer()
            Text("Venue Stats")
                .foregroundColor(.white)
            VStack(spacing: 8) {
                
                VStack(spacing: 4) {
                    VenueStatRow(title: "Matches Played", value: "\(venueInfo.venueStats.matchesPlayed)")
                    Divider().background(Color.white)
                    VenueStatRow(title: "Lowest Defended", value: "\(venueInfo.venueStats.lowestDefended)")
                    Divider().background(Color.white)
                    VenueStatRow(title: "Highest Chased", value: "\(venueInfo.venueStats.highestChased)")
                    Divider().background(Color.white)
                    VenueStatRow(title: "Win Bat First", value: "\(venueInfo.venueStats.batFirstWins)")
                    Divider().background(Color.white)
                    VenueStatRow(title: "Win Ball First", value: "\(venueInfo.venueStats.ballFirstWins)")
                }
                VStack(spacing: 4) {
                    Divider().background(Color.white)
                    HStack {
                        Spacer()
                        Spacer()
                        Text("1st Inn")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                        Spacer(minLength: 1)
                        Text("2nd Inn")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.gray)
                    }
                    Divider().background(Color.white)
                    VenueStatRow(title: "Avg Score", value: "\(venueInfo.venueStats.battingFirst.averageScore)", secondValue: "\(venueInfo.venueStats.battingSecond.averageScore)")
                    Divider().background(Color.white)
                    VenueStatRow(title: "Highest Score", value: "\(venueInfo.venueStats.battingFirst.highestScore)", secondValue: "\(venueInfo.venueStats.battingSecond.highestScore)")
                    Divider().background(Color.white)
                    VenueStatRow(title: "Lowest Score", value: "\(venueInfo.venueStats.battingFirst.lowestScore)", secondValue: "\(venueInfo.venueStats.battingSecond.lowestScore)")
                    Divider().background(Color.white)
                    VenueStatRow(title: "Pace Wickets", value: "\(venueInfo.venueStats.battingFirst.paceWickets)", secondValue: "\(venueInfo.venueStats.battingSecond.paceWickets)")
                    Divider().background(Color.white)
                    VenueStatRow(title: "Spin Score", value: "\(venueInfo.venueStats.battingFirst.spinWickets)", secondValue: "\(venueInfo.venueStats.battingSecond.spinWickets)")
                }
            }
            .padding()
            .background(Color.black.opacity(0.2))
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
        }
        .padding()
        .background(Color.black)
        .cornerRadius(10)
        .shadow(radius: 10)
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
