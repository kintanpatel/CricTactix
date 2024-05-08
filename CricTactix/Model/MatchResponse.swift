//
//  MatchResponse.swift
//  CricTactix
//
//  Created by kintan on 08/05/24.
//

import Foundation
struct MatchResponse: Codable {
    let results: Results
}

struct Results: Codable {
    let fixture: Fixture
    let liveDetails: LiveDetails?
    
    enum CodingKeys: String, CodingKey {
        case fixture
        case liveDetails = "live_details"
    }
}
struct Fixture: Codable {
    let away: Team
    let dates: [DateDetail]
    let endDate: String
    let home: Team
    let matchTitle: String
    let seriesID: Int
    let startDate: String
    let venue: String
    
    enum CodingKeys: String, CodingKey {
        case away, dates, endDate = "end_date", home, matchTitle = "match_title", seriesID = "series_id", startDate = "start_date", venue
    }
}
 
struct DateDetail: Codable {
    let date: String
    let matchSubtitle: String
    
    enum CodingKeys: String, CodingKey {
        case date, matchSubtitle = "match_subtitle"
    }
}
struct LiveDetails: Codable {
    let matchSummary: MatchSummary
    let officials: Officials
    let scorecard: [ScoreCard]
//    let stats: Stats
//    let teamsheets: [TeamSheet]?
    
    enum CodingKeys: String, CodingKey {
        case matchSummary = "match_summary"
        case officials, scorecard
    }
}
struct MatchSummary: Codable {
    let awayScores, homeScores, inPlay, result, toss,status: String?
    
    enum CodingKeys: String, CodingKey {
        case awayScores = "away_scores"
        case homeScores = "home_scores"
        case inPlay = "in_play"
        case result, toss,status
    }
}

struct Officials: Codable {
    let referee, umpire1, umpire2, umpireReserve, umpireTV: String
    
    enum CodingKeys: String, CodingKey {
        case referee, umpire1 = "umpire_1", umpire2 = "umpire_2", umpireReserve = "umpire_reserve", umpireTV = "umpire_tv"
    }
}

struct ScoreCard: Codable {
    let batting: [BattingDetail]
    let bowling: [BowlingDetail]
    let current: Bool
    let extras: Int
    let extrasDetail, fow: String
    let inningsNumber: Int
    let overs: String
    let runs: Int
    let stillToBat: [StillToBat]
    let title, wickets: String
    
    enum CodingKeys: String, CodingKey {
        case batting, bowling, current, extras
        case extrasDetail = "extras_detail"
        case fow
        case inningsNumber = "innings_number"
        case overs, runs
        case stillToBat = "still_to_bat"
        case title, wickets
    }
}

struct BattingDetail: Codable {
    let balls, batOrder, fours: Int
    let howOut: String
    let minutes: String
    let playerID: Int
    let playerName: String
    let runs, sixes: Int
    let strikeRate: String
    
    enum CodingKeys: String, CodingKey {
        case balls, batOrder = "bat_order", fours
        case howOut = "how_out"
        case minutes
        case playerID = "player_id"
        case playerName = "player_name"
        case runs, sixes
        case strikeRate = "strike_rate"
    }
}

struct BowlingDetail: Codable {
    let dotBalls: Int
    let economy, extras: String
    let fours, maidens: Int
    let overs: String
    let playerID: Int
    let playerName: String
    let runsConceded, sixes, wickets: Int
    
    enum CodingKeys: String, CodingKey {
        case dotBalls = "dot_balls"
        case economy, extras, fours, maidens, overs
        case playerID = "player_id"
        case playerName = "player_name"
        case runsConceded = "runs_conceded"
        case sixes, wickets
    }
}

struct StillToBat: Codable {
    let  playerID: Int
    let playerName: String
    
    enum CodingKeys: String, CodingKey {
        case playerID = "player_id"
        case playerName = "player_name"
    }
}
struct Stats: Codable {
    let currentRunRate: String
    
        
    let lastUpdate, minRemainingOvers, partnershipOvers, partnershipPlayer1: String?
    let partnershipPlayer1Balls, partnershipPlayer1Runs, partnershipPlayer2: Int?
    let partnershipPlayer2Balls, partnershipPlayer2Runs, partnershipRunRate: Int?
    let partnershipRuns: Int
    
    enum CodingKeys: String, CodingKey {
        case currentRunRate = "current_run_rate"
        case lastUpdate = "last_update"
        case minRemainingOvers = "min_remaining_overs"
        case partnershipOvers = "partnership_overs"
        case partnershipPlayer1 = "partnership_player_1"
        case partnershipPlayer1Balls = "partnership_player_1_balls"
        case partnershipPlayer1Runs = "partnership_player_1_runs"
        case partnershipPlayer2 = "partnership_player_2"
        case partnershipPlayer2Balls = "partnership_player_2_balls"
        case partnershipPlayer2Runs = "partnership_player_2_runs"
        case partnershipRunRate = "partnership_run_rate"
        case partnershipRuns = "partnership_runs"
    }
}

struct TeamSheet: Codable {
    // Define TeamSheet properties here
}
