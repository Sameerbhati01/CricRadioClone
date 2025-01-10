//
//  MiniScorecard.swift
//  CricRadioColne
//
//  Created by Sameer Bhati on 08/01/25.
//

import Foundation

struct MiniScorecard: Codable {
    let powerplay: String
    let powerplayOver: Int
    let key: String
    let status: String
    let format: String
    let announcement1: String
    let teams: Teams
    let now: Now
    let currentBattingOrder: Int
    let settingObj: Setting
    let lastCommentary: Commentary
    let announcement2: String?

    struct Teams: Codable {
        let a: Team
        let b: Team
        
        struct Team: Codable {
            let name: String
            let shortName: String
            let logo: String
            let score1: Score?
            let score2: Score?

            enum CodingKeys: String, CodingKey {
                case name
                case shortName
                case logo
                case score1 = "a_1_score"
                case score2 = "a_2_score"
            }

            struct Score: Codable {
                let runs: Int
                let overs: String?
                let wickets: Int
                let declare: Bool
            }
        }
    }

    struct Now: Codable {
        let runRate: String
        let reqRunRate: String
        let sessionLeft: String?

        enum CodingKeys: String, CodingKey {
            case runRate = "run_rate"
            case reqRunRate = "req_run_rate"
            case sessionLeft
        }
    }

    struct Setting: Codable {
        let currentTeam: String
        let currentInning: Int
    }

    struct Commentary: Codable {
        let primaryText: String
        let secondaryText: String?
        let tertiaryText: String?
        let isDone: Bool
    }
}

struct MiniScorecardResponse: Codable {
    let responseData: ResponseData

    struct ResponseData: Codable {
        let result: MiniScorecard
    }
}
