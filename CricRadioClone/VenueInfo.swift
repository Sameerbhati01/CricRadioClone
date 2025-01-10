//
//  VenueInfo.swift
//  CricRadioColne
//
//  Created by Sameer Bhati on 08/01/25.
//

import Foundation

struct VenueInfo: Codable {
    let id: String
    let firstUmpire: String
    let format: String
    let key: String
    let matchReferee: String
    let relatedName: String
    let season: Season
    let secondUmpire: String
    let startDate: StartDate
    let status: String
    let teams: Teams
    let thirdUmpire: String
    let toss: Toss
    let venue: String
    let venueDetails: VenueDetails
    let weather: Weather
    let venueStats: VenueStats
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case firstUmpire
        case format
        case key
        case matchReferee
        case relatedName = "related_name"
        case season
        case secondUmpire = "secoundUmpire"
        case startDate = "start_date"
        case status
        case teams
        case thirdUmpire
        case toss
        case venue
        case venueDetails
        case weather
        case venueStats
    }

    struct Season: Codable {
        let key: String
        let name: String
    }

    struct StartDate: Codable {
        let timestamp: Int
        let iso: String
        let str: String
        let skyCheckTs: Int

        enum CodingKeys: String, CodingKey {
            case timestamp
            case iso
            case str
            case skyCheckTs = "sky_check_ts"
        }
    }

    struct Teams: Codable {
        let a: Team
        let b: Team

        struct Team: Codable {
            let name: String
            let shortName: String
            let logo: String
        }
    }

    struct Toss: Codable {
        let won: String
        let decision: String
        let str: String
    }

    struct VenueDetails: Codable {
        let id: String
        let knownAs: String
        let capacity: Int
        let createdAt: String
        let cricinfoId: Int
        let description: String
        let ends1: String
        let ends2: String
        let floodLights: Int
        let homeTo: String
        let isDeleted: String
        let opened: String?
        let photo: String
        let status: String
        let timezone: String
        let updatedAt: String
        let venueLocation: String
        let venueScraptitle: String
        let venueInfo: VenueInfoDetails

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case knownAs
            case capacity
            case createdAt
            case cricinfoId
            case description
            case ends1
            case ends2
            case floodLights
            case homeTo
            case isDeleted
            case opened
            case photo
            case status
            case timezone
            case updatedAt
            case venueLocation
            case venueScraptitle
            case venueInfo = "venue_info"
        }

        struct VenueInfoDetails: Codable {
            let name: String
            let smallName: String
            let longName: String
            let location: String
            let town: String
        }
    }

    struct Weather: Codable {
        let location: String
        let condition: Condition
        let chanceOfRain: Int
        let tempC: Double
        let lastUpdated: String

        enum CodingKeys: String, CodingKey {
            case location
            case condition
            case chanceOfRain = "chance_of_rain"
            case tempC = "temp_c"
            case lastUpdated = "last_updated"
        }

        struct Condition: Codable {
            let code: Int
            let icon: String
            let text: String
        }
    }

    struct VenueStats: Codable {
        let matchesPlayed: Int
        let lowestDefended: Int
        let highestChased: Int
        let batFirstWins: Int
        let ballFirstWins: Int
        let battingFirst: Batting
        let battingSecond: Batting

        struct Batting: Codable {
            let averageScore: Int
            let highestScore: Int
            let lowestScore: Int
            let paceWickets: Int
            let spinWickets: Int
        }
    }
}

struct VenueInfoResponse: Codable {
    let responseData: ResponseData

    struct ResponseData: Codable {
        let result: VenueInfo
    }
}
