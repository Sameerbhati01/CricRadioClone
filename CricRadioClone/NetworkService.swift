//
//  NetworkService.swift
//  CricRadioColne
//
//  Created by Sameer Bhati on 08/01/25.
//

import Foundation

struct NetworkService {
    static let baseURL = "http://3.6.243.12:5001"
    static let authorizationHeader = "Basic Y3JpY2tldFJhZGlvOmNyaWNrZXRAJCUjUmFkaW8xMjM="
    
    static func fetchMiniScorecard() async throws -> MiniScorecard {
        guard let url = URL(string: "\(baseURL)/api/v2/match/mini-match-card?key=SA_vs_SL_2024-12-05_1732276435.300452") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        
        let decoder = JSONDecoder()
        let responseObject = try decoder.decode(MiniScorecardResponse.self, from: data)
        return responseObject.responseData.result
    }
    
    static func fetchVenueInfo() async throws -> VenueInfo {
        guard let url = URL(string: "\(baseURL)/api/v2/match/venue-info?key=SA_vs_SL_2024-12-05_1732276435.300452") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
        }
        
        let decoder = JSONDecoder()
        let responseObject = try decoder.decode(VenueInfoResponse.self, from: data)
        return responseObject.responseData.result
    }
}
