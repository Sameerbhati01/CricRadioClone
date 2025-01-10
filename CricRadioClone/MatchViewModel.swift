//
//  MatchViewModel.swift
//  CricRadioColne
//
//  Created by Sameer Bhati on 08/01/25.
//

import Foundation
import Combine

class MatchViewModel: ObservableObject {
    @Published var miniScorecard: MiniScorecard?
    @Published var venueInfo: VenueInfo?
    @Published var errorMessage: String?
    
    func fetchMatchData() {
        Task {
            do {
                let scorecard = try await NetworkService.fetchMiniScorecard()
                DispatchQueue.main.async {
                    self.miniScorecard = scorecard
                }
                
                let venueInfo = try await NetworkService.fetchVenueInfo()
                DispatchQueue.main.async {
                    self.venueInfo = venueInfo
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
